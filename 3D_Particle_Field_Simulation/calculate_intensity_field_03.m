function intensity_field=calculate_intensity_field_03(intensity_field_parameters,X,Y,Z,R);
% This function creates the 3D intensity field with size and coordinates
% specified by intensity_field_parameters and with particle positions
% specified by the (X,Y,Z) vectors.  The vector R is the peak intensity of 
% the particles.
%
% Version 02 is designed to run faster than version 01.  This is
% accomplished by setting a threshhold below which the Gaussian function is
% not calculated.  Then only the voxels that have intensities higher than
% this are calculated and added to the full array.
%
% Version 03 is based upon version 02, except that it is designed to run
% with a lower memory requirement by avoiding creating the full coordinate
% arrays for the images and rather creating individual coordinate arrays
% surrounding each particle.  This will come at a small speed cost, but it
% is likely less then a 10% difference in speed and results in an
% approximately 75% reduction in memory requirements.
%
% Authors: Rod La Foy
% First Created On: 8 April 2014
% Last Modified On: 8 April 2014

% This is the threshhold ratio with respect to the maximum value or R 
% below which the Gaussian function is not calculated
threshhold_ratio = 2^-16;

% This the number of voxels to simulate in each dimension
X_Voxel_Number = intensity_field_parameters.X_Voxel_Number;
Y_Voxel_Number = intensity_field_parameters.Y_Voxel_Number;
Z_Voxel_Number = intensity_field_parameters.Z_Voxel_Number;

% This is the domain of the world coordinates to image that will lie within
% the 3D intensity field
X_Voxel_Min_Position = intensity_field_parameters.X_Voxel_Min_Position;
X_Voxel_Max_Position = intensity_field_parameters.X_Voxel_Max_Position;
Y_Voxel_Min_Position = intensity_field_parameters.Y_Voxel_Min_Position;
Y_Voxel_Max_Position = intensity_field_parameters.Y_Voxel_Max_Position;
Z_Voxel_Min_Position = intensity_field_parameters.Z_Voxel_Min_Position;
Z_Voxel_Max_Position = intensity_field_parameters.Z_Voxel_Max_Position;

% This is the standard deviation of the Gaussian filter
gaussian_filter_standard_deviation = intensity_field_parameters.gaussian_filter_standard_deviation;

% This is a vector of X positions within the 3D intensity field
X_Voxel_Position = linspace(X_Voxel_Min_Position,X_Voxel_Max_Position,X_Voxel_Number);
% This is a vector of Y positions within the 3D intensity field
Y_Voxel_Position = linspace(Y_Voxel_Min_Position,Y_Voxel_Max_Position,Y_Voxel_Number);
% This is a vector of Z positions within the 3D intensity field
Z_Voxel_Position = linspace(Z_Voxel_Min_Position,Z_Voxel_Max_Position,Z_Voxel_Number);

% This is the size of each voxel in the X direction in microns (although
% they should be the same in the three dimensions)
dX_Voxel_Width = (X_Voxel_Max_Position-X_Voxel_Min_Position)/(X_Voxel_Number-1);

% This is the standard deviation of the Gaussian function for each particle
% (in microns)
gaussian_std_world_coordinates = dX_Voxel_Width*gaussian_filter_standard_deviation;

% This initializes the 3D intensity field array
I = zeros(Y_Voxel_Number,X_Voxel_Number,Z_Voxel_Number);

% This is the radius of the kernal over which the Gaussian function
% needs to evaluated
kernal_radius = ceil(sqrt(-2*(gaussian_filter_standard_deviation^2)*log(max(R)*threshhold_ratio)));

% These are the indices of the particles that are outside of the volume
remove_indices = ((X<X_Voxel_Min_Position)|(X>X_Voxel_Max_Position));
remove_indices = remove_indices|((Y<Y_Voxel_Min_Position)|(Y>Y_Voxel_Max_Position));
remove_indices = remove_indices|((Z<Z_Voxel_Min_Position)|(Z>Z_Voxel_Max_Position));

% This removes the particles that are outside the range of the volume
X(remove_indices) = [];
Y(remove_indices) = [];
Z(remove_indices) = [];
R(remove_indices) = [];

% This iterates through the particles generating the Guassian intensity
% field
for n = 1:length(X);
    
    % This displays the current progress in creating the intensity field
%     display_calculation_progress(n,1:length(X));
    
    % These are the current particles coordinates
    X_Current = X(n);
    Y_Current = Y(n);
    Z_Current = Z(n);
    % This is the current particles intensity
    R_Current = R(n);
    
    % This is the index closest to the center of the current particle
    [~,ii_center] = min(abs(Y_Current-Y_Voxel_Position));
    [~,jj_center] = min(abs(X_Current-X_Voxel_Position));
    [~,kk_center] = min(abs(Z_Current-Z_Voxel_Position));
    
    % This is the range of indices over which to calculate the Gaussian
    % function
    ii_min = ii_center-kernal_radius;
    ii_max = ii_center+kernal_radius;
    jj_min = jj_center-kernal_radius;
    jj_max = jj_center+kernal_radius;
    kk_min = kk_center-kernal_radius;
    kk_max = kk_center+kernal_radius;
    
    % If the minimum or maximum ii indices are outside the range of the
    % volume, then this sets them to the limits of the volume
    ii_min = 1*(ii_min<1)+ii_min*((1< = ii_min)&(ii_min< = Y_Voxel_Number))+Y_Voxel_Number*(ii_min>Y_Voxel_Number);
    ii_max = 1*(ii_max<1)+ii_max*((1< = ii_max)&(ii_max< = Y_Voxel_Number))+Y_Voxel_Number*(ii_max>Y_Voxel_Number);
    % If the minimum or maximum jj indices are outside the range of the
    % volume, then this sets them to the limits of the volume
    jj_min = 1*(jj_min<1)+jj_min*((1< = jj_min)&(jj_min< = X_Voxel_Number))+X_Voxel_Number*(jj_min>X_Voxel_Number);
    jj_max = 1*(jj_max<1)+jj_max*((1< = jj_max)&(jj_max< = X_Voxel_Number))+X_Voxel_Number*(jj_max>X_Voxel_Number);
    % If the minimum or maximum kk indices are outside the range of the
    % volume, then this sets them to the limits of the volume
    kk_min = 1*(kk_min<1)+kk_min*((1< = kk_min)&(kk_min< = Z_Voxel_Number))+Z_Voxel_Number*(kk_min>Z_Voxel_Number);
    kk_max = 1*(kk_max<1)+kk_max*((1< = kk_max)&(kk_max< = Z_Voxel_Number))+Z_Voxel_Number*(kk_max>Z_Voxel_Number);
    
    % This creates the coordinate arrays for evaluating the Gaussian
    % function
    [X_Voxel_Position_Array,Y_Voxel_Position_Array,Z_Voxel_Position_Array] = meshgrid(X_Voxel_Position(jj_min:jj_max),Y_Voxel_Position(ii_min:ii_max),Z_Voxel_Position(kk_min:kk_max));
    
    % These are the Gaussian radial coordinates for the current calculation
    rho = (X_Current-X_Voxel_Position_Array).^2+(Y_Current-Y_Voxel_Position_Array).^2+(Z_Current-Z_Voxel_Position_Array).^2;
    
    % This is the Gaussian function of the current particle
    G = R_Current*exp(-(rho/(2*gaussian_std_world_coordinates^2)));
    
    % This adds the current particles intensity field to the total field
    I(ii_min:ii_max,jj_min:jj_max,kk_min:kk_max) = I(ii_min:ii_max,jj_min:jj_max,kk_min:kk_max)+G;
    
end;

% This creates a structure to save the intensity field data into
intensity_field = struct();

% This saves the voxel positions into the structure
intensity_field.X_Voxel_Position = X_Voxel_Position;
intensity_field.Y_Voxel_Position = Y_Voxel_Position;
intensity_field.Z_Voxel_Position = Z_Voxel_Position;

% This saves the (discretized) particle positions into the structure
intensity_field.X_Particle_Position = X;
intensity_field.Y_Particle_Position = Y;
intensity_field.Z_Particle_Position = Z;

% This saves the particle intensities into the structure
intensity_field.R_Particle_Radiance = ones(size(X));

% This saves the intensity field into the structure
intensity_field.I = I;

end