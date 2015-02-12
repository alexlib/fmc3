num_images = size(imageMatrix1, 4);
close all
plot_dir = '~/Desktop/sphere_plots';


v = double(imageMatrix1(:, :, :, 1));
sph_proj = spherical_projection(v, 64, 1);
sphere3d((sph_proj)', 0, 2*pi, -pi/2, pi/2, 1, 1, 'surf', 'spline', 1E-10);
view(3);
zoom(1.8)
set(gcf, 'color', 'black');
cam_view = get(gca, 'view');
set(gcf, 'inverthardcopy', 'off');



cam_angles = linspace(cam_view(1), cam_view(1) + 360, num_images);


for k = 1 : num_images
   % Spherical projection of volume

   set(gca, 'view', [cam_angles(k), cam_view(2)]);
   
   file_name = ['plot_' num2str(k, '%05d') '.jpg'];
   file_path = fullfile(plot_dir, file_name);
   
   
   print(1, '-djpeg', file_path);
  

    
end