function create_3d_particle_field_image_01;
% This function is a basic template function for simulating 3D particle
% field intensity images.  The function first creates a data structure 
% named 'intensity_field_parameters' that contains the parameters defining 
% the size, coordinates, and particle size of the intensity field.  Next,
% the function simulates a set of particle coordinates, and finally the
% function creates the 3D intensity field.

% This is the number of particles to simulate
particle_number = 1000;

% This is the directory in which to save the 3D particle field image
directory_write = '~/Desktop/test_fields';

% This creates the intensity field paramaters data structure
intensity_field_parameters = create_intensity_field_parameters;

% This is the domain over which to simulate the particles
X_Voxel_Min_Position = intensity_field_parameters.X_Voxel_Min_Position;
X_Voxel_Max_Position = intensity_field_parameters.X_Voxel_Max_Position;
Y_Voxel_Min_Position = intensity_field_parameters.Y_Voxel_Min_Position;
Y_Voxel_Max_Position = intensity_field_parameters.Y_Voxel_Max_Position;
Z_Voxel_Min_Position = intensity_field_parameters.Z_Voxel_Min_Position;
Z_Voxel_Max_Position = intensity_field_parameters.Z_Voxel_Max_Position;

% This creates the particle position vectors
X_Particle_Coordinates = rand(particle_number,1)*(X_Voxel_Max_Position-X_Voxel_Min_Position)+X_Voxel_Min_Position;
Y_Particle_Coordinates = rand(particle_number,1)*(Y_Voxel_Max_Position-Y_Voxel_Min_Position)+Y_Voxel_Min_Position;
Z_Particle_Coordinates = rand(particle_number,1)*(Z_Voxel_Max_Position-Z_Voxel_Min_Position)+Z_Voxel_Min_Position;

% This creates the distribution of particle intensities
R_Particle_Intensity = 0.1*randn(particle_number,1)+0.8;
% This sets any particles outside of the range 0 < R < 1 equal to the
% domain extrema
R_Particle_Intensity(R_Particle_Intensity<0) = 0;
R_Particle_Intensity(R_Particle_Intensity>1) = 1;

% This creates the 3D particle intensity field
intensity_field = calculate_intensity_field_03(intensity_field_parameters,X_Particle_Coordinates,Y_Particle_Coordinates,Z_Particle_Coordinates,R_Particle_Intensity);

% This extracts the particle field image
I = intensity_field.I;

% This is the prefix of the intensity fields
intensity_field_prefix = intensity_field_parameters.intensity_field_prefix;

% This is the filename to save the intensity field to
filename_write = fullfile(directory_write, [intensity_field_prefix, sprintf('%04.0f',1),'.mat']);

% This saves the intensity field
save(filename_write,'I','-v7.3');

end



function intensity_field_parameters = create_intensity_field_parameters;
% This function creates a parameters structure for describing the 3D
% intensity field to be simulated.

% This is the domain in world coordinates of the simulated volume (this
% current reconstructs half of the total simulated volume)
X_Voxel_Min_Position = -0.5;
X_Voxel_Max_Position = +0.5;
Y_Voxel_Min_Position = -0.5;
Y_Voxel_Max_Position = +0.5;
Z_Voxel_Min_Position = -0.5;
Z_Voxel_Max_Position = +0.5;

% This the number of voxels to simulate in each dimension
X_Voxel_Number = 128;
Y_Voxel_Number = 128;
Z_Voxel_Number = 128;

% This is the standard deviation of the Gaussian particles (in voxels)
gaussian_filter_standard_deviation = 0.7;

% This is the prefix of the true intensity fields
intensity_field_prefix = 'intensity_field_';

% This initializes the intensity field parameters structure
intensity_field_parameters = struct();
% This the number of voxels to simulate in each dimension
intensity_field_parameters.X_Voxel_Number = X_Voxel_Number;
intensity_field_parameters.Y_Voxel_Number = Y_Voxel_Number;
intensity_field_parameters.Z_Voxel_Number = Z_Voxel_Number;
% This is the domain in world coordinates of the simulated volume
intensity_field_parameters.X_Voxel_Min_Position = X_Voxel_Min_Position;
intensity_field_parameters.X_Voxel_Max_Position = X_Voxel_Max_Position;
intensity_field_parameters.Y_Voxel_Min_Position = Y_Voxel_Min_Position;
intensity_field_parameters.Y_Voxel_Max_Position = Y_Voxel_Max_Position;
intensity_field_parameters.Z_Voxel_Min_Position = Z_Voxel_Min_Position;
intensity_field_parameters.Z_Voxel_Max_Position = Z_Voxel_Max_Position;
% This is the standard deviation of the Gaussian filter
intensity_field_parameters.gaussian_filter_standard_deviation = gaussian_filter_standard_deviation;
% This is the prefix of the intensity fields
intensity_field_parameters.intensity_field_prefix = intensity_field_prefix;

end


