function [ALPHA, GAMMA, BETA] = make_euler_angle_grid_3D(BAND_WIDTH)
% This function creates matrices of spherical coordinates
% that are consistent with the SOFT library in C.
%
% INPUTS
%   BAND_WIDTH: Band width of the function, e.g., half the sampling rate on
%   the equiangular grid (integer).
%
% OUTPUTS
%   ALPHA = Angular coordinate corresponding to the final 
%       rotation about the Z axis, i.e., the the third (left-most) Euler
%       angle (Radians). This is a matrix of dimensions 2B x 2B x 2B, with
%       B = BAND_WIDTH
%
%   GAMMA = Angular coordinate corresponding to rotation about the
%       original Z axis, i.e., the first (right-most) Euler angle
%       (Radians). This is a matrix of dimensions 2B x 2B x 2B, with
%       B = BAND_WIDTH
%  
%   BETA = Angular coordinate corresponding to rotation about the Y axis
%       after rotation about the Z axis by GAMMA, i.e., the second (middle)
%       Euler angle (Radians). This is a matrix of dimensions
%       2B x 2B x 2B, with B = BAND_WIDTH


% Calculate the number of azimuthal and elevation samples
num_samples = 2 * BAND_WIDTH;
                        
% This is the range of indices to be consistent with the 
% SOFT package in C
inds = [0, 2 * BAND_WIDTH - 1];
                        
% This calculates the minimum and maximum angles 
% about the z-axis in order to be consistent with
% the SOFT package in C.
alpha_range = 2 * pi * inds / (2 * BAND_WIDTH);
gamma_range = 2 * pi * inds / (2 * BAND_WIDTH);

% These are the minimum and maximum elevation angles
% expressed as colatitude, which is the complement of latitude.
% This means that a colatitude of 0 corresponds to the north pole,
% versus a latitude of 0 corresponds to the equator.
%
% Colatitude is used in order to be consistent with the SOFT package in C.
%
% This is a good place to check for errors if things aren't working.
beta_range_colatitude = pi * (2 * inds + 1) / (4 * BAND_WIDTH);

% This converts the colatitude to normal latitude,
% in order to make the coordinates compatible with
% Matlab's sph2cart function.
% The leading pi/2 accounts for the fact that SOFT is expecting
% the colatitude (complementary angle of latitude) to vary between
% 0 to pi, while Matlab's sph2cart works with latitude.
beta_range_latitude = pi/2 - beta_range_colatitude;
  
% This creates a vector of z-rotation angles in radians.
alpha_vector = linspace(alpha_range(1), alpha_range(2), num_samples);
gamma_vector = linspace(gamma_range(1), gamma_range(2), num_samples);

% This creates a vector of elevation coordinates in radians.
beta_vector = linspace(beta_range_latitude(1), beta_range_latitude(2), num_samples);

% Create a 2D grid of spherical coordinates from
% the[az, el, r] coordinate vectors.
% This matrix is ordered such that elevation angles are constant
% across rows and azimuth angles are constant across columns.
[ALPHA, GAMMA, BETA] = meshgrid(alpha_vector, gamma_vector, beta_vector);


end