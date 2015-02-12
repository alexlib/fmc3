function plot_soft_correlation(CORRELATION_VALUES, PARAMS)

% Axis color
axis_color = 0.6 * [1, 1, 1];

% Figure color
figure_color = 0.15 * [1, 1, 1];

% Font size
axis_font_size = 12;
label_font_size = 18;


% Size of the data
[height, width, depth] = size(CORRELATION_VALUES);

% % Create coordinate matrix
% [x, y, z] = meshgrid(1 : width, 1 : height, 1 : depth);
% 
% % Locate the maximum value of the correlation plane.
% [~, max_loc] = max(CORRELATION_VALUES(:));

% Ranges of axes
x_range = 2 * [0, 1];
y_range = 2 * [0, 1];
z_range = 1 * [0, 1];
      
% Create the plot
h = vol3d('cdata', CORRELATION_VALUES, 'texture', '3D',...
    'XData', x_range,...
    'YData', y_range, ...
    'ZData', z_range);

alphamap('rampup');
axis square;
view(3);

% Set plot background colors
set(gcf, 'color', figure_color);
set(gca, 'color', figure_color);

% Set axis colors
set(gca, 'xcolor', axis_color);
set(gca, 'ycolor', axis_color);
set(gca, 'zcolor', axis_color);

% Set axis font size
set(gca, 'FontSize', axis_font_size);

% % Set the camera position
% set(gca, 'CameraPosition', ...
%     [874.2663 -628.0328  369.5475]);

% Set the camera position
set(gca, 'CameraPosition', ...
    [9.7442,  -13.4189, 2.4770]);

% Turn on box
box on;

% % Set number of ticks
n_ticks_x = 5;
n_ticks_y = 5;
n_ticks_z = 5;

x_tick_vect = linspace(min(x_range), max(x_range), n_ticks_x);
y_tick_vect = linspace(min(y_range), max(y_range), n_ticks_y);
z_tick_vect = linspace(min(z_range), max(z_range), n_ticks_z);

% % Set tick marks
set(gca, 'xtick', x_tick_vect);
set(gca, 'ytick', y_tick_vect);
set(gca, 'ztick', z_tick_vect);

% Label axes
xlabel('\gamma / \pi', 'Interpreter', 'tex', 'FontSize', label_font_size);
ylabel('\alpha / \pi', 'Interpreter', 'tex', 'FontSize', label_font_size);
zlabel('\beta / \pi' , 'Interpreter', 'tex', 'FontSize', label_font_size);


end




