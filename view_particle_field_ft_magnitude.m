
% Add paths
addpath vol3d;

% Directory containing the field data
field_dir = fullfile('~/Desktop');

% File name of field data
data_file_name = 'raw_image_matrix_lin_h64_w64_seg_000001_000100';

% Path to the data file
data_file_path = fullfile(field_dir, data_file_name);

% Load the data file
load(data_file_path);

I = double(imageMatrix1);

vol_size = size(I(:, :, :, 1));

g = gaussianWindowFilter_3D(vol_size, 0.63 * [1, 1, 1], 'fraction');

nImages = size(I, 4);

% Color limits for FT magnitude
ca = [4 17];

axis_colors = 0.6 * [1, 1, 1];

for k = 1 : nImages
    fprintf(1, '%d of %d\n', k, nImages);
    close all
%     figure('visible', 'off');
    
    ax1 = subplot(1, 2, 1);
    vol3d('cdata', g.*I(:, :, :, k), 'texture', '3D');
    grid on
    set(gca, 'xtick', linspace(1, 64, 5));
    set(gca, 'ytick', linspace(1, 64, 5));
    set(gca, 'ztick', linspace(1, 64, 5));
    set(gca, 'xticklabel', {});
    set(gca, 'yticklabel', {});
    set(gca, 'zticklabel', {});
    set(gca, 'color', 'black');
    set(gca, 'xcolor', axis_colors);
    set(gca, 'ycolor', axis_colors);
    set(gca, 'zcolor', axis_colors);
    alphamap('rampup');
    box on
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
    
    % Create a volume visualization of the data.
    vol3d('cdata', ft_mag, 'texture', '3D');
    set(gca, 'ALim', [2 20]);
    caxis(ca);
    view(3);
%     colormap('gray');
    alphamap('rampup');
    xlim([1 64]);
    ylim([1 64]);
    zlim([1 64]);
    colormap(cmap);
%     colormap hot;
    % set(gca, 'color', 'white');
    axis image
    box on
    title('FT Magnitude', 'FontSize', 20);
    set(gca, 'FontSize', 10);
    xlabel('U');
    ylabel('V');
    zlabel('W');
    
    set(gca, 'xtick', linspace(1, 64, 5));
    set(gca, 'ytick', linspace(1, 64, 5));
    set(gca, 'ztick', linspace(1, 64, 5));
    set(gca, 'xticklabel', {});
    set(gca, 'yticklabel', {});
    set(gca, 'zticklabel', {});
    set(gca, 'xcolor', axis_colors);
    set(gca, 'ycolor', axis_colors);
    set(gca, 'zcolor', axis_colors);
    set(gca, 'color', 'black');
    grid on;
    
    set(gcf, 'color', 'black');
    set(gcf, 'invertHardcopy', 'off');
    
%     drawnow;
    print(1, '-djpeg', fullfile('~/Desktop/plots_02',...
        ['plot_' num2str(k, '%04d') '.jpg']));
  

end



% [data_sph] = cart3_to_sph3(ft_mag, 128, 128, 64, 64, 64, 64, 2);
% 
% data_sph_2d = spherical_projection(data_sph);
% 
% sphere3d(data_sph_2d, 0, 2*pi, -pi/2, pi/2, 1, 1, 'surf', 'spline', 1E-5);


