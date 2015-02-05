function [DATA_SPHERICAL_3D, AZ, EL, R] = ...
    cart3_to_sph3(DATA_CARTESIAN_3D,...
    NUM_AZIMUTH_SAMPLES, NUM_ELEVATION_SAMPLES, NUM_RADIAL_SAMPLES,...
    X_CENTER, Y_CENTER, Z_CENTER, R_MIN, R_MAX)
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

% Create a 3D grid of cartesian coordinates centered about
% X_CENTER, Y_CENTER, Z_CENTER. This should be moved out of this function
% for speed.
[x_cart, y_cart, z_cart] = meshgrid(...
                            (1 : width)  - X_CENTER, ...
                            (1 : height) - Y_CENTER, ...
                            (1 : depth)  - Z_CENTER ...
                            );

% This creates a grid of spherical coordinates
% on which the volumetric Cartesian data will be resampled.
% "azimuth_vector" is the azimuthal angular coordinate in radians.
azimuth_vector = linspace(-pi, pi, NUM_AZIMUTH_SAMPLES);

% This is the elevation angular coordinate in radians
% (the word "elevation" is reserved by Matlab)
elevation_vector = linspace(-pi/2, pi/2, NUM_ELEVATION_SAMPLES);

% Default to a max radius of the largest circle that
% can be inscribed on the volumetric data.
if nargin < 9
    R_MAX = min([height, width, depth]) / 2 - 1;
end

% This is the radial coordinate.
radial_vector = linspace(R_MIN, R_MAX, NUM_RADIAL_SAMPLES); 

% Create a 3D grid of spherical coordinates from
% the[az, el, r] coordinate vectors.
% This should be moved out of this function for speed.
[AZ, EL, R] = meshgrid(azimuth_vector, elevation_vector, radial_vector);

% Convert the 3D spherical coordinates to 3D cartesian coordinates
[x_sph, y_sph, z_sph] = sph2cart(AZ, EL, R);

% Resample the 3D Cartesian data onto the spherical coordinate grid
DATA_SPHERICAL_3D = interp3(x_cart, y_cart, z_cart,...
                            DATA_CARTESIAN_3D, ...
                            x_sph, y_sph, z_sph);

end




