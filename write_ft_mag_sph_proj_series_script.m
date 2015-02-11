file_path = '~/Desktop/raw_image_matrix_lin_h64_w64_seg_000001_000100.mat';

% Directory containing the compiled SOFT routines.
output_dir = '~/Desktop/soft_test/data_files/volumes_02';
% output_dir = '~/Desktop/soft_test/data_files/ft_mag';

% Bandwidth of the data
band_width = 64;

% Make the soft dir if it doesn't exist
if ~exist(output_dir, 'dir');
    mkdir(output_dir);
end

% Load volumes
load(file_path);

% Measure size of volumes
[height, width, depth] = size(imageMatrix1(:, :, :, 1));

% Number of images
num_images = size(imageMatrix1, 4);

% Create a Gaussian window
g = gaussianWindowFilter_3D([height, width, depth], ...
    0.63 * [1, 1, 1], 'fraction');

for k = 1 : num_images
   file_name = ['input_data_vol_' num2str(k, '%03d') '.dat'];
   file_path = fullfile(output_dir, file_name); 
   vol = double(imageMatrix1(:, :, :, k));
   
   write_volume_sph_proj(vol, band_width, file_path);

%    write_ft_mag_sph_proj(g .* vol, band_width, file_path)
   
end
