function varargout = rect2phasor(RectInput, opts)
%% rect2phasor.m
% Converts a rectangular coordinate (complex value) to phasor (polar) form. 
% Optional arguments can configure:
%   - Units of the phase (degrees or radians).
%   - Output as formatted text or numerical arrays.
% This function works with any sized input (complex value).
% When printing formatted text, rect2phasor will enforce engineering
% notation (format short eng style).
%
%   Syntax: [outputs] = rect2phasor(RectInput, options);
%       Let inputValues = [1+1j, -0.02-13j; 47e3+500j, 33e-12+5e-9j];
%
%       Produce formatted phasors in units of degrees (default):
%       phasors = rect2phasor(inputValues)
%
%       Any previous syntax (but now reporting phase in radians)
%       phasors = rect2phasor(___, "AngleUnits", "radians")
%
%       Any previous syntax (but now returning Mag and Phase arrays)
%       [Mag, Phase] = rect2phasor(___, "ReturnData", true)
%       
%   Required Inputs:
%       RectInput
%           An array of rectangular (complex) data to be converted to
%           phasor. Can be a single number or array.
%   Name/Value Pairs (optional):
%       AngleUnits [default is "degrees"]
%           Specifies the units of the phase angle. Can be "degrees" or
%           "radians".
%       ReturnData [default is false]
%           Determines if output is a formatted string (mag angle phase
%           units) or if the output shall return two numeric arrays (mag 
%           and phase).
%           If ReturnData=true, returns mag and phase arrays.
%           If ReturnData=false [default], returns formatted strings.
%
%   Outputs:
%       [Phasors]
%           If ReturnData is set to false, returns the formatted phasor
%           notation (as an array of strings).
%       [Mag, Phase]
%           If ReturnData is set to true, returns the magnitude and phase.
%
%   Example Calls:
%       inputValues = [1+1j, -0.02-13j; 47e3+500j, 33e-12+5e-9j]
%            inputValues =
%                 1.0000e+000 +  1.0000e+000i   -20.0000e-003 - 13.0000e+000i
%                47.0000e+003 +500.0000e+000i    33.0000e-012 +  5.0000e-009i
%
%       Produce phasors in degrees
%       Phasors = rect2phasor(inputValues)
%            Phasors = 
%              2×2 string array
%                "1.4142e+000 ∠ 45.0000e+000°"      "13.0000e+000 ∠ -90.0881e+000°"
%                "47.0027e+003 ∠ 609.5070e-003°"    "5.0001e-009 ∠ 89.6219e+000°"
%
%       Produce phasors in radians
%       Phasors = rect2phasor(inputValues, "AngleUnits", "radians")
%            Phasors = 
%              2×2 string array
%                "1.4142e+000 ∠ 785.3980e-003 rad"    "13.0000e+000 ∠ -1.5723e+000 rad"
%                "47.0027e+003 ∠ 10.6379e-003 rad"    "5.0001e-009 ∠ 1.5642e+000 rad"  
%       
%       Get arrays of magnitudes and phases (in degrees)
%       [Mag, Phase] = rect2phasor(inputValues, "ReturnData", true)
%            Mag =
%                 1.4142e+000    13.0000e+000
%                47.0027e+003     5.0001e-009
%            Phase =
%                45.0000e+000   -90.0881e+000
%               609.5066e-003    89.6219e+000
%
%
%       Get arrays of magnitudes and phases (in radians)
%       [Mag, Phase] = rect2phasor(inputValues, "AngleUnits", "radians", "ReturnData", true)
%            Mag =
%                 1.4142e+000    13.0000e+000
%                47.0027e+003     5.0001e-009
%            Phase =
%               785.3982e-003    -1.5723e+000
%                10.6379e-003     1.5642e+000
%
%   Authors and Revisions:
%       Brian Faulkner      - Original core code.
%       Devon Lantagne      - Modified to handle units, multiple 
%                             dimensions, and output formatting.

% Process Arguments and Defaults
arguments
    RectInput (:,:) double
    opts.AngleUnits (1,1) string {ismember(opts.AngleUnits, ["degrees", "radians"])} = "degrees"
    opts.ReturnData (1,1) logical = false
end

% Compute Phasor
Mags = abs(RectInput); % Computes magnitudes for all elements
Phases = angle(RectInput); % Computes phases (in radians) for all elements

% Handle Units
units = " rad";
if opts.AngleUnits == "degrees"
    Phases = rad2deg(Phases);
    units = string(char(176));
end

% Return Outputs
if opts.ReturnData
    % Return the magnitude and phase arrays directly
    varargout{1} = Mags;
    varargout{2} = Phases;
else
    % Format the phasors, stash them in a string array
    OldFormat = format(); % save current formatting configuration
    format short eng % change formatting to engineering
    DispEng = @(value) strtrim(evalc(sprintf('disp(%g)', value))); % Capture the engineering output
    FormatFunction = @(mag,phase) sprintf("%s %c %s%s", ...
        DispEng(mag), 8736, DispEng(phase), units); % Function to format phasor strings
    FormattedStrings = arrayfun(FormatFunction, Mags, Phases); % Execute format function on all elements of input
    varargout{1} = FormattedStrings; % Return output
    format(OldFormat) % Restore user's format configuration
end

end
