
% Add paths
addpath vol3d;

% Directory containing the field data
field_dir = fullfile('data', 'test_fields');

% File name of field data
data_file_name = 'intensity_field_0001.mat';

% Path to the data file
data_file_path = fullfile(field_dir, data_file_name);

% Load the data file
load(data_file_path);

% Take the 3D FFT of the data
ft = fftn(WINDOW .* I, size(I));

% Take the magnitude of the FT
ft_mag = log(abs(ft));

[data_sph] = cart3_to_sph3(ft_mag, 128, 128, 64, 64, 64, 64, 2);

data_sph_2d = spherical_projection(data_sph);

sphere3d(data_sph_2d, 0, 2*pi, -pi/2, pi/2, 1, 1, 'surf', 'spline', 1E-5);

% Create a volume visualization of the data.
vol3d('cdata', I, 'texture', '3D');
view(3);
alphamap('rampup');
colormap hot;
set(gca, 'color', 'black');
axis image
box on

