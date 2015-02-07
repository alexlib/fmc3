
% Specify file path to volumes
file_path = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/fmc3/analysis/data/synthetic/lin/2015-02-02_volume_test_lin/64x64/raw/lin_h64_w64_00001/raw/raw_image_matrix_lin_h64_w64_seg_000001_000025.mat';

% Directory containing the compiled SOFT routines.
soft_dir = '~/Desktop/soft_test';

% Bandwidth of the data
band_width = 64;

% Make the soft dir if it doesn't exist
if ~exist(soft_dir, 'dir');
    mkdir(soft_dir);
end

% Load volumes
load(file_path);

% Measure size of volumes
[height, width, depth] = size(imageMatrix1(:, :, :, 1));

% Create a Gaussian window
g = gaussianWindowFilter_3D([height, width, depth], ...
    0.63 * [1, 1, 1], 'fraction');

% Window the two volumes
volume_01 = double(imageMatrix1(:, :, :, 1));
volume_02 = double(imageMatrix1(:, :, :, end));

% Specify the filepaths on which to save the data
file_path_01 = fullfile(soft_dir, 'input_data_01.dat');
file_path_02 = fullfile(soft_dir, 'input_data_02.dat');

% Write the .dat files
write_volume_sph_proj_temp(volume_01, band_width, file_path_01);
write_volume_sph_proj_temp(volume_02, band_width, file_path_02);

% Build command for running C code
function_name = 'test_soft_fftw_correlate2';
function_path = fullfile(soft_dir, function_name);
deg_lim = 8;
results_path = fullfile(soft_dir, 'result.dat');

cmd = ['!pushd ' soft_dir '; ./' function_name ' ' ...
    file_path_01 ' ' ...
    file_path_02 ' ' ...
    num2str(band_width) ' ' ...
    num2str(band_width) ' ' ...
    deg_lim ' ' ...
    results_path '; pushd'];

eval(cmd);




