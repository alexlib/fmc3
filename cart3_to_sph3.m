function [DATA_SPHERICAL_3D, AZ, EL, R] = ...
    cart3_to_sph3(DATA_CARTESIAN_3D, BAND_WIDTH, R_MIN)
% This function resamples volumetric data from a 3D Cartesian grid to 
% a 3D spherical grid centered at X_CENTER, Y_CENTER, Z_CENTER,
% with NUM_AZIMUTHAL_SAMPLES azimuthal angular samples,
% NUM_ELEVATION_SAMPLES elevational angular samples, and NUM_RADIAL_SAMPLES
% radial samples taken from a minimum radius of R_MIN to a maximum radius
% of R_MAX. The argument R_MAX is optional; R_MAX defaults to the radius
% of the largest sphere centered at X_CENTER, Y_CENTER, Z_CENTER
% that can be inscribed on the volumetric cartesian data.
% Resampling is performed using spline interpolation.

% This is the number of rows, columns, and slices of
% the volumetric Cartesian data.
[height, width, depth] = size(DATA_CARTESIAN_3D);

% Default to minimum radius of one voxel
if nargin < 3
    R_MIN = 1;
end

% This calculates the maximum radius of resampling.
r_max = min([height, width, depth]) / 2 - 1;

% Calculate the number of radial samples to use
% This number is twice the number of samples that would lie
% along the data radius.
num_radial_samples = 2 * min([height, width, depth]);

% Calculate the coordinates of the geometric centroid
% of the region. This assumes the coordinates
% are order in matlab meshgrid format, i.e., 
% arrays start at (1, 1, 1) (versus (0, 0, 0) for C, Python, etc.)
xc = (width  + 1) / 2;
yc = (height + 1) / 2;
zc = (depth  + 1) / 2;

% Create a 3D grid of cartesian coordinates centered about
% X_CENTER, Y_CENTER, Z_CENTER. This should be moved out of this function
% for speed.
[x_cart, y_cart, z_cart] = meshgrid(...
                            (1 : width)  - xc, ...
                            (1 : height) - yc, ...
                            (1 : depth)  - zc ...
                            );

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
az_vector   = linspace(az_range(1), az_range(2), num_samples);

% This creates a vector of elevation coordinates in radians.
el_vector = linspace(el_range_latitude(1), el_range_latitude(2), num_samples);

% This is the radial coordinate.
radial_vector = linspace(R_MIN, r_max, num_radial_samples); 

% Create a 3D grid of spherical coordinates from
% the[az, el, r] coordinate vectors.
% This should be moved out of this function for speed.
[EL, AZ, R] = meshgrid(el_vector, az_vector, radial_vector);

% Convert the 3D spherical coordinates to 3D cartesian coordinates
[x_sph, y_sph, z_sph] = sph2cart(AZ, EL, R);

% Resample the 3D Cartesian data onto the spherical coordinate grid
DATA_SPHERICAL_3D = interp3(x_cart, y_cart, z_cart,...
                            DATA_CARTESIAN_3D, ...
                            x_sph, y_sph, z_sph);

end




