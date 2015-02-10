function [AZ, EL] = make_spherical_coordinates_2D(BAND_WIDTH)
% This function creates matrices of spherical coordinates
% that are consistent with the SOFT library in C.
%
% INPUTS
%
%   BAND_WIDTH = Band width of the spherical function, i.e., half
%       the sampling rate on the equiangular spherical grid (integer).
%
%   OUTPUTS
%       AZ = Azimuth angle in radians. The range of AZ is 
%       pi * k /  B, where k = [0, 2 * B - 1], and
%       B = BAND_WIDTH
%
%       EL = Elevation angle in radians. The range of EL is
%       2 * pi * k / (2 * B), where k = [0, 2 * B - 1],
%       and B = BAND_WIDTH

% Calculate the number of azimuthal and elevation samples
num_samples = 2 * BAND_WIDTH;
                        
% This is the range of indices to be consistent with the 
% SOFT package in C
inds = [0, 2 * BAND_WIDTH - 1];
                        
% This calculates the minimum and maximum azimuth angles
% in order to be consistent with the SOFT package in C.
az_range = 2 * pi * inds / (2 * BAND_WIDTH);

% These are the minimum and maximum elevation angles
% expressed as colatitude, which is the complement of latitude.
% This means that a colatitude of 0 corresponds to the north pole,
% versus a latitude of 0 corresponds to the equator.
%
% Colatitude is used in order to be consistent with the SOFT package in C.
%
% This is a good place to check for errors if things aren't working.
el_range_colatitude = pi * (2 * inds + 1) / (4 * BAND_WIDTH);

% This converts the colatitude to normal latitude,
% in order to make the coordinates compatible with
% Matlab's sph2cart function.
% The leading pi/2 accounts for the fact that SOFT is expecting
% the colatitude (complementary angle of latitude) to vary between
% 0 to pi, while Matlab's sph2cart works with latitude.
el_range_latitude = pi/2 - el_range_colatitude;
  
% This creates a vector of azimuthal coordinates in radians.
azimuth_vector   = linspace(az_range(1), az_range(2), num_samples);

% This creates a vector of elevation coordinates in radians.
elevation_vector = linspace(el_range_latitude(1), el_range_latitude(2), num_samples);

% Create a 2D grid of spherical coordinates from
% the[az, el, r] coordinate vectors.
% This matrix is ordered such that elevation angles are constant
% across rows and azimuth angles are constant across columns.
[EL, AZ] = meshgrid(elevation_vector, azimuth_vector);


end