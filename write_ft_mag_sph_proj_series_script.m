data_rep = '~/Desktop/soft_test/data_files';

data_name = 'raw_image_matrix_lin_h64_w64_seg_000001_000064';

data_type = 'ft_mag';

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

% 3D coordinates
[x, y, z] = meshgrid(1 : width, 1 : height, 1 : depth);

% Origin
xc = (width + 1)  / 2;
yc = (height + 1) / 2;
zc = (depth + 1)  / 2;

% Radial coordinate
r = sqrt((x - xc).^2 + (y - yc).^2 + (z - zc).^2);

% Cutoff coordinate
rc = round(min([width, depth, height])/6);

% % Create a gaussian window for windowing the FT volume.
% g2 = gaussianWindowFilter_3D([height, width, depth], ...
%     0.5 * [1, 1, 1], 'fraction');

window_02 = double(r < rc);


for k = 1 : 1 : num_images
    
   fprintf(1, 'Image %d of %d\n', k, num_images); 
    
   output_file_name = ['input_data_' data_type '_' num2str(k, '%03d') '.dat'];
   output_file_path = fullfile(output_dir, output_file_name); 
   vol = double(imageMatrix1(:, :, :, k));
   
   if isVol
       write_volume_sph_proj(vol, band_width, output_file_path);
   else  
       write_ft_mag_sph_proj(g .* vol, band_width, window_02, output_file_path);
   end
   

end
