
% Directory containing the field data
field_dir = fullfile('data', 'test_fields');

% File name of field data
data_file_name = 'intensity_field_0001.mat';

% Path to the data file
data_file_path = fullfile(field_dir, data_file_name);

% Load the data file
load(data_file_path);

% Create a volume visualization of the data.
vol3d('cdata', I, 'texture', '2D');
view(3);
alphamap('rampup');
colormap hot;
set(gca, 'color', 'black');
axis image
