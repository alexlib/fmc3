function [CORRELATION_VALUES, GAMMA, BETA, ALPHA] = ...
    read_soft_results_file(RESULTS_FILE_PATH, BAND_WIDTH, IS_REAL)
% This function reads a correlation volume produced by the c function
% test_soft_fftw_correlate2.
%
% INPUTS
%   RESULTS_FILE_PATH = Path to the output file produced by
%       test_soft_fftw_correlate2 (string). For details on the format
%       of these files, see section 2.3 of the documentation for the SOFT
%       library, "Data Conventions: Ordering of Samples and Coefficients"
%       (document named "soft20_fx.pdf");
%
%   BAND_WIDTH = Bandwidth of the inverse SOFT (integer), i.e., half the
%       sampling rate on the equiangular 3D grid of Euler angles.
%
%   IS_REAL = Boolean flag specifying whether the output data were purely
%       real (IS_REAL = 1), in which case the data are sequentially ordered, 
%       or if the output data were complex (IS_REAL = 0), in which case the 
%       data are interleaved(e.g., data(i) = file(i) + 1i * file(i + 1), etc).
%
% OUTPUTS
%   CORRELATION_VALUES = Array of scalar correlation values corresponding
%       to the three Euler angles. This is a matrix of dimensions
%       2B x 2B x 2B, with B = BAND_WIDTH.
%
%   GAMMA = Angular coordinate corresponding to rotation about the
%       original Z axis, i.e., the first (right-most) Euler
%       angle (Radians). This is a matrix of dimensions 2B x 2B x 2B,
%       with B = BAND_WIDTH.
%  
%   BETA = Angular coordinate corresponding to rotation about the Y axis
%       after rotation about the Z axis by GAMMA, i.e., the second (middle)
%       Euler angle (Radians). This is a matrix of dimensions 2B x 2B x 2B,
%       with B = BAND_WIDTH.
%
%   ALPHA = Angular coordinate corresponding to the final 
%       rotation about the Z axis, i.e., the the third (left-most) Euler
%       angle (Radians). This is a matrix of dimensions 2B x 2B x 2B,
%       with B = BAND_WIDTH.

% Default to real data
if nargin < 3
    IS_REAL = 1;
end

% Open the file specified by RESULTS_FILE_PATH for reading only
fid = fopen(RESULTS_FILE_PATH, 'r');

% Create a grid of the azimuthal and elevation coordinates
% based on the band width of the output file
[ALPHA, GAMMA, BETA] = make_spherical_coordinates_3D(BAND_WIDTH);

% Number of azimuth and elevation samples
num_alpha_samples = 2 * BAND_WIDTH;
num_gamma_samples = 2 * BAND_WIDTH;
num_beta_samples  = 2 * BAND_WIDTH;

% Allocate a matrix to hold the correlation values
% CORRELATION_VALUES = fscanf(fid, '%f');
CORRELATION_VALUES = zeros(2 * BAND_WIDTH * [1, 1, 1]);

% Read the results file line by line, populating
% the matrix of correlation values
for b = 1 : num_beta_samples
    for a = 1 : num_alpha_samples
        for g = 1 : num_gamma_samples
            if IS_REAL
                % Read real values from the data ordered sequentially.
                CORRELATION_VALUES(g, a, b) = fscanf(fid, '%f', 1);
            else
                % Read complex values from the data file in interleaved format.
                CORRELATION_VALUES(g, a, b) = fscanf(fid, '%f', 1) + 1i * fscanf(fid, '%f', 1);
            end
        end
    end
end

% Close the file
fclose(fid);

end


