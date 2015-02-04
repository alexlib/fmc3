function view_particle_field(FIELD)

% Create a volume visualization of the data.
vol3d('cdata', FIELD, 'texture', '3D');
view(3);
alphamap('rampup');
colormap hot;
set(gca, 'color', 'black');
axis image
box on

end

