function [DATA_SPHERICAL_2D, AZ, EL] = ...
    spherical_projection(DATA_CARTESIAN_3D, BAND_WIDTH, R_MIN)


% Default to minimum radius of resampling
% of one voxel
if nargin < 3
    R_MIN = 1;
end

% Resample the 3D Cartesian data onto 
% a 3D spherical grid.
[DATA_SPHERICAL_3D, az, el] = ...
    cart3_to_sph3(DATA_CARTESIAN_3D, BAND_WIDTH, R_MIN);

% Sum the spherical data along the radial direction 
% to create its spherical projection.
DATA_SPHERICAL_2D = sum(DATA_SPHERICAL_3D, 3);

% Remove the radial index from the azimuth and
% elevation coordinate arrays.
AZ = az(:, :, 1);
EL = el(:, :, 1);

end





