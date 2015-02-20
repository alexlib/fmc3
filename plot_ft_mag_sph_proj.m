% function plot_ft_mag_sph_proj

% Font size for plots
fSize = 18;

data_rep = '~/Desktop/soft_test/data_files';

data_name = 'raw_image_matrix_z_rot_lin_h64_w64_seg_000001_000100';

data_type = 'ft_mag';

mat_dir = fullfile(data_rep, data_type, 'mat');

% Directory containing the compiled SOFT routines.
output_dir = '~/Desktop/sph_proj_plots';

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

g2 = double(r < rc);

% Set a color axis for the FT magnitudes
% This is just based on trial and error for what looks good.
ft_caxis = 1E7 * [2.557108877200716, 5.557649086528796];

% Color axis for particle images
particle_caxis = 1E5 * [0, 4.046006565736852];

for k = 1 : 1 : num_images
    
   fprintf(1, 'Image %d of %d\n', k, num_images); 
    
   output_file_name = ['plot_' num2str(k, '%05d') '.jpg'];
   output_file_path = fullfile(output_dir, output_file_name); 
   vol = double(imageMatrix1(:, :, :, k));
   
   vol_proj = spherical_projection(vol, band_width);
   
   ft_mag_proj = ft_mag_sph_proj(g .* vol, band_width, g2);
   
   % Make a subplot for the raw spherical projection
   ax1 = subplot(1, 2, 1);
   imagesc(vol_proj);
   axis image;
   caxis(particle_caxis);
   title({'3D Particle volume', 'Spherical projection'}, 'FontSize', fSize);
   set(gca, 'xtick', []);
   set(gca, 'ytick', []);
   axis off
   
   % Make a subplot for the FT mag spherical projection
   ax2 = subplot(1, 2, 2);
   imagesc(ft_mag_proj);
   axis image;
   caxis(ft_caxis);
   title({'3D FT magnitude', 'Spherical projection'}, 'FontSize', fSize);
   set(gca, 'xtick', []);
   set(gca, 'ytick', []);
   
   drawnow;
   
   % Save the plot.
   print(1, '-djpeg', output_file_path);

end











