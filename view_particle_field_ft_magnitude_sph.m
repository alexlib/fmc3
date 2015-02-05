
% Add paths
addpath vol3d;

% Directory containing the field data
field_dir = fullfile('/Users/matthewgiarra/Documents/School/VT/Research/Aether/fmc3/analysis/data/synthetic/lin/2015-02-02_volume_test_lin/64x64/raw/lin_h64_w64_00001/raw/');

% File name of field data
data_file_name = 'raw_image_matrix_lin_h64_w64_seg_000001_000025';

% Path to the data file
data_file_path = fullfile(field_dir, data_file_name);

% Load the data file
load(data_file_path);

I = double(imageMatrix1);

vol_size = size(I(:, :, :, 1));

[height, width, depth] = size(I(:, :, :, 1));

g = gaussianWindowFilter_3D(vol_size, 0.63 * [1, 1, 1], 'fraction');

nImages = size(I, 4);

% Color limits for FT magnitude
ca = [1.0038,...
        1.0043];

% axis_colors = 0 * [1, 1, 1];

 num_azimuth_samples = 2*width;
 num_elevation_samples = width;
 num_radial_samples = width/2;
 x_center = width/2;
 y_center = height/2;
 z_center = depth/2;
 r_min = 2;
 r_max = width/2;


for k = 1 : nImages
    fprintf(1, '%d of %d\n', k, nImages);
%     close all
%     figure('visible', 'off');
    
    ax1 = subplot(1, 2, 1);
    vol3d('cdata', g.*I(:, :, :, k), 'texture', '3D');
    set(gca, 'color', 'black');
    alphamap('rampup');
    colormap hot
    caxis(1E4 * [0 3.0]);
    xlim([1 64]);
    ylim([1 64]);
    zlim([1 64]);
%     set(gca, 'view', [0, 0]);
    view(3);
    axis image;
    set(gca, 'color', 'black');
    colormap hot;
    set(gca, 'FontSize', 10);
%     set(gca, 'xcolor', axis_color);
%     set(gca, 'ycolor', axis_color);
%     set(gca, 'zcolor', axis_color);
    title('Particle Volume', 'FontSize', 20);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    freezeColors;

    ax2 = subplot(1, 2, 2);
    % Take the 3D FFT of the data
    ft = fftshift(fftn(g .* I(:, :, :, k), vol_size));

    % Take the magnitude of the FT
    ft_mag = log(abs(ft));
    
    data_spherical_2D = ...
    spherical_projection(ft_mag, ...
                         num_azimuth_samples, ...
                         num_elevation_samples, ...
                         num_radial_samples, ...
                         x_center,...
                         y_center, ...
                         z_center,...
                         r_min);
                     
    % Project the FT magnitude onto the unit sphere.
    sphere3d(flipud(data_spherical_2D), 0, 2*pi, -pi/2, pi/2, 1, 1, 'surf', 'spline', 1E-5);
    
    % Create a volume visualization of the data.
%     vol3d('cdata', ft_mag, 'texture', '3D');
    view(3);
%     colormap(map);
    colormap jet;
    t2 = title({'FT Magnitude', 'Spherical Projection'}, 'FontSize', 20);
    p = get(t2, 'position');
    p(3) = 1.03;
    set(t2, 'position', p);
    set(gca, 'FontSize', 10);
    set(gcf, 'invertHardcopy', 'off');
    caxis(ca);
    
    zoom(1.6);
    
    drawnow;
%     print(1, '-djpeg', fullfile('~/Desktop/plots_02/sph',...
%         ['plot_' num2str(k, '%04d') '.jpg']));
  

end



% [data_sph] = cart3_to_sph3(ft_mag, 128, 128, 64, 64, 64, 64, 2);
% 
% data_sph_2d = spherical_projection(data_sph);
% 
% sphere3d(data_sph_2d, 0, 2*pi, -pi/2, pi/2, 1, 1, 'surf', 'spline', 1E-5);


