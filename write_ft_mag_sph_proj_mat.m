function write_ft_mag_sph_proj_mat(VOLUME, BAND_WIDTH, WINDOW, FILEPATH)
% This function computes the spherical projection of the 
% FT magnitude of the 3D volume VOLUME and writes its
% values to a .dat file located along FILEPATH.
%
% The order of the data is as follows:
% The entire array is written as a single column vector
% with longitude iterating faster than colatitude,
% e.g., a sampling of all the longitudes at each colatitude.


% Resample the FT magnitude onto the unit sphere.
[data_sph, az, el] = ft_mag_sph_proj(VOLUME, BAND_WIDTH, WINDOW);
                     
% Open a file for writing                     
fid = fopen(FILEPATH, 'w');

% Loop over the whole array, writing out 
% each value on a separate line. The function 
% spherical_projection orders the spherial projection
% such that azimuth angles are constant across columns 
% and elevation angles are constant across rows.
% In other words, different rows represent different
% azimuth angles and different columns represent
% different elevation angles.
for e = 1 : length(el) 
    for a = 1 : length(az)
       fprintf(fid, '%f\n%d\n', data_sph(a, e), 0); 
    end
end
    
% Close the file
fclose(fid);

end
















