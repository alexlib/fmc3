% run_soft_script


% Axis color
axis_color = 0.6 * [1, 1, 1];

% Figure color
figure_color = 0.15 * [1, 1, 1];

% Font size
labelFontSize = 18;

addpath freezeColors;

base_dir = '/Users/matthewgiarra/Desktop/soft_test';

is_real = 1;

% Data type
data_type = 'ft_mag';

mat_dir    = fullfile(base_dir, 'data_files', data_type, 'mat');
data_dir   = fullfile(base_dir, 'data_files', data_type, 'dat');   
corr_dir   = fullfile(base_dir, 'data_files', data_type, 'corr'); 
plot_dir   = fullfile(base_dir, 'data_files', data_type, 'plot');
parameters_dir = fullfile(base_dir, 'data_files',  data_type, 'parameters');

band_width_in  = 64;
band_width_out = 32;

% Max order of transforms
max_order = 7;

start_file = 1;
end_file = 100;
skip_file = 1;

file_base = ['input_data_' data_type '_'];
file_ext = '.dat';
n_digits = 3;
num_format = ['%0' num2str(n_digits) 'd'];

% Correlation file base
corr_file_base = [data_type '_corr_'];

% Volume file base
mat_file_name = 'raw_image_matrix_lin_h64_w64_seg_000001_000100.mat';

% Volume file path
mat_file_path = fullfile(mat_dir, mat_file_name);

% Parameters file name
parameters_file_name = 'imageParameters_lin_h64_w64_seg_000001_000100.mat';

% Parameters file path
parameters_file_path = fullfile(parameters_dir, parameters_file_name);

% Load the paremeters file
load(parameters_file_path);

% Load the raw volumes path
load(mat_file_path);


% Make the output dir if it doesn't exist
if ~exist(plot_dir, 'dir');
    mkdir(plot_dir)
end

% List of file numbers
file_nums = start_file : skip_file : end_file;

% Number of files
num_files = length(file_nums);

% Close any open figures
close all

xo = 32;
yo = 32;
zo = 32;

dx = 12;
dy = 12;
dz = 12;

% Fixed axis points
x_points = [xo, xo + dx
            xo, xo; 
            xo, xo];

y_points = [yo, yo; 
            yo, yo + dy; 
            yo, yo];

z_points = [zo, zo;
            zo, zo;
            zo, zo + dz];

    
% Clear axes
cla;

% Loop over all the files
for k = 25 : 1 : 25
    
    % Measure rotation angle in radians
    R = -1 * Parameters.Rotation(k, 2);
    
    % Correlation file name and path
    corr_file_name = [corr_file_base, ...
        num2str(file_nums(1), num_format), '_' ...
        num2str(file_nums(k), num_format), file_ext];
    corr_file_path = fullfile(corr_dir, corr_file_name);
     
   
    % Read the SOFT results .dat file
    [C, G, B, A] = read_soft_results_file(corr_file_path, band_width_out, is_real);
   
    
end










