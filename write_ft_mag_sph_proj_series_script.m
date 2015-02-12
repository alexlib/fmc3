data_rep = '~/Desktop/soft_test/data_files';

data_name = 'raw_image_matrix_lin_h64_w64_seg_000001_000100.mat';

data_type = 'vol';

mat_dir = fullfile(data_rep, data_type, 'mat');

% Directory containing the compiled SOFT routines.
output_dir = fullfile(data_rep, data_type, 'dat');

% Bandwidth of the data
band_width = 64;

% Make the soft dir if it doesn't exist
if ~exist(output_dir, 'dir');
    mkdir(output_dir);
end

% Data file path
input_file_path = fullfile(mat_dir, data_name);

% Load volumes
load(input_file_path);

% Measure size of volumes
[height, width, depth] = size(imageMatrix1(:, :, :, 1));

% Number of images
num_images = size(imageMatrix1, 4);

isVol = ~isempty(regexpi(data_type, 'vol'));


% Create a Gaussian window
g = gaussianWindowFilter_3D([height, width, depth], ...
    0.63 * [1, 1, 1], 'fraction');


for k = 1 : num_images
   output_file_name = ['input_data_vol_' num2str(k, '%03d') '.dat'];
   output_file_path = fullfile(output_dir, output_file_name); 
   vol = double(imageMatrix1(:, :, :, k));
   
   if isVol
       write_volume_sph_proj(vol, band_width, output_file_path);
   else  
       write_ft_mag_sph_proj(g .* vol, band_width, output_file_path);
   end
   

end
