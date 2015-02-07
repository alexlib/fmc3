
num_steps = 60;

B = 32;

xgv = -2 : 0.1 : 2;
ygv = xgv;
zgv = xgv;
[x, y, z] = meshgrid(xgv, ygv, zgv);
V = rand(size(x));


[az, el, r] = cart2sph(x, y, z);

azv = linspace(-pi, pi, B);
elv = linspace(-pi/2, pi/2, B);
rv = linspace(0, 2, B);

[el, az, r] = meshgrid(elv, azv, rv);

% Final radius
rf = 10;

save_base = 'image_';
save_dir = '~/Desktop/files';

for k = 0 : num_steps
   
    r_shift = r + (k / num_steps) * (rf - r);
    xlim([-15 15]);
    ylim([-15 15]);
    zlim([-15 15]);
    [x2, y2, z2] = sph2cart(az, el, r_shift);
    plot3(x2(:), y2(:), z2(:), '.w', 'markersize', 2);
    set(gcf, 'inverthardcopy', 'off');
    axis image;
    view(3)
    set(gca, 'color', 'black');
    set(gcf, 'color', 'black');
    axis off;
    pause(0.1);
    print(1, '-djpeg', fullfile(save_dir, [save_base num2str(k, '%05d') '.jpg']));
    
end

hold on

for k = 1 : size(x2, 1)-1
    mesh( x2(1:k+1, :, 1), y2(1:k+1, :, 1), z2(1:k+1, :, 1),'facealpha', 0.2, 'facecolor', 'white', 'edgecolor', 'white', 'linewidth', 0.1)
    
    print(1, '-dpng', '-r200', fullfile(save_dir, [save_base num2str(num_steps + k, '%05d') '.png']));
    
end

hold off



