function write_ft_mag_sph_proj(VOLUME, BANDWIDTH, FILEPATH)
% This function computes the spherical projection of the 
% FT magnitude of the 3D volume VOLUME and writes its
% values to a .dat file located along FILEPATH.
%
% The order of the data is as follows:
% The entire array is written as a single column vector
% with longitude iterating faster than colatitude,
% e.g., a sampling of all the longitudes at each colatitude.
% 

% Measure the dimensions of the volume
[height, width, depth] = size(VOLUME);

% Sampling parameters
num_azimuth_samples   = 2 * BANDWIDTH - 1;
num_elevation_samples = 2 * BANDWIDTH - 1;
num_radial_samples = round(min([height, width, depth]) / 2);

% Geometric centroid
x_center = width/2;
y_center = height/2;
z_center = depth/2;

% Minimum radius of resampling
r_min = 1;

% Take the magnitude of the 3D FT of the data
FT = abs(fftshift(fftn(VOLUME, [height, width, depth])));

% Resample the FT magnitude onto the unit sphere.
[data_sph, az, el] = spherical_projection(FT, ...
                         num_azimuth_samples, ...
                         num_elevation_samples, ...
                         num_radial_samples, ...
                         x_center,...
                         y_center, ...
                         z_center,...
                         r_min);
                     
% Open a file for writing                     
fid = fopen(FILEPATH, 'w');

% Loop over the whole array, writing out 
% each value on a separate line. 
for a = 1 : length(az) 
    for e = 1 : length(el)
       fprintf(fid, '%0.6f\n', data_sph(a, e)); 
    end
end
    
% Close the file
fclose(fid);

end
















