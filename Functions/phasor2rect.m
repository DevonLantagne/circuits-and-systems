function rectOutput = phasor2rect(Magnitudes, Phases, opts)
%% phasor2rect.m
% Converts a phasor to rectangular (complex) form.
% Optional arguments can configure:
%   - Units of the input phase (degrees or radians).
% This function works with any sized input (so long as Magnitudes and 
%   Phases are the same size).
%
%   Syntax: [outputs] = phasor2rect(Magnitudes, Phases, options);
%       Let Magnitudes and Phases be an array of real values. The size of
%           Magnitudes and Phases must be the same.
%
%       Produce rectangular form from phasors with phase in degrees:
%       rectOutput = phasor2rect(Magnitudes, Phases)
%
%       Produce rectangular form from phasors with phase in radians:
%       rectOutput = phasor2rect(Magnitudes, Phases, "InputUnits", "radians")
%       
%   Required Inputs:
%       RectInput
%           An array of rectangular (complex) data to be converted to
%           phasor. Can be a single number or array.
%   Name/Value Pairs (optional):
%       InputUnits [default is "degrees"]
%           Specifies the units of the phasor's phase angle. Can be 
%           "degrees" or "radians".
%
%   Outputs:
%       [Phasors]
%           If ReturnData is set to false, returns the formatted phasor
%           notation (as an array of strings).
%       [Mag, Phase]
%           If ReturnData is set to true, returns the magnitude and phase.
%
%   Example Calls:
%       Let:
%           Mag = [1, 20; -5, 1];
%           Phase = [45, -30; 0 90]; % In degrees
%           Phase_rad = [50 100; 20 300]; % in radians
%
%       Produce rectangular from phasors (in degrees)
%       rectOutput = phasor2rect(Mag, Phase)
%            rectOutput =
%               707.1068e-003 +707.1068e-003i    17.3205e+000 - 10.0000e+000i
%                -5.0000e+000 +  0.0000e+000i    61.2323e-018 +  1.0000e+000i
%
%       rectOutput = phasor2rect(Mag, Phase, "InputUnits", "radians")
%            rectOutput =
%               964.9660e-003 -262.3749e-003i    17.2464e+000 - 10.1273e+000i
%                -2.0404e+000 -  4.5647e+000i   -22.0966e-003 -999.7558e-003i
%
%   Authors and Revisions:
%       Brian Faulkner      - Original core code.
%       Devon Lantagne      - Modified to handle units and multiple 
%                             dimensions.

% Process Arguments and Defaults
arguments
    Magnitudes (:,:) double
    Phases (:,:) double
    opts.InputUnits (1,1) string {ismember(opts.InputUnits, ["degrees", "radians"])} = "degrees"
end

% Set phase to radians if not already
if opts.InputUnits == "degrees"
    Phases = deg2rad(Phases);
end

% Compute rectangular form
rectOutput = Magnitudes .* exp(1j.*Phases);

end
