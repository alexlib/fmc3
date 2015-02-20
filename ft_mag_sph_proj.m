function [DATA_SPH, AZ, EL] = ft_mag_sph_proj(VOLUME, BAND_WIDTH, WINDOW)
% This function computes the spherical projection of the 
% FT magnitude of the 3D volume VOLUME and writes its
% values to a .dat file located along FILEPATH.
%
% The order of the data is as follows:
% The entire array is written as a single column vector
% with longitude iterating faster than colatitude,
% e.g., a sampling of all the longitudes at each colatitude.

% Default to no window
if nargin < 3
    WINDOW = ones(size(VOLUME), 'double');
end

% Measure the dimensions of the volume
[height, width, depth] = size(VOLUME);

% Take the magnitude of the 3D FT of the data
FT = abs(fftshift(fftn(VOLUME, [height, width, depth])));

% Resample the FT magnitude onto the unit sphere.
[DATA_SPH, AZ, EL] = spherical_projection(WINDOW .* FT, BAND_WIDTH);

end
















