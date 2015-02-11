function plot_soft_correlation(CORRELATION_VALUES)

% Axis color
axis_color = 0.6 * [1, 1, 1];

% Figure color
figure_color = 0.15 * [1, 1, 1];

% Font size
fSize = 16;

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
z_range = 1 / 2 * [-1, 1];
      
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
set(gca, 'FontSize', fSize);

% % Set the camera position
% set(gca, 'CameraPosition', ...
%     [874.2663 -628.0328  369.5475]);

% Set the camera position
set(gca, 'CameraPosition', ...
    [14.4639, -9.4307, 1.5752]);

% Turn on box
box on;

% % Set number of ticks
% n_ticks_x = 5;
% n_ticks_y = 5;
% n_ticks_z = 5;

% % Set tick marks
% set(gca, 'xtick', linspace(min(x_range), max(x_range), n_ticks_x));
% set(gca, 'ytick', linspace(min(y_range), max(y_range), n_ticks_y));
% set(gca, 'ztick', linspace(min(z_range), max(z_range), n_ticks_z));

% Label axes
xlabel('\gamma / \pi', 'Interpreter', 'tex', 'FontSize', 30);
ylabel('\alpha / \pi', 'Interpreter', 'tex', 'FontSize', 30);
zlabel('\beta / \pi' , 'Interpreter', 'tex', 'FontSize', 30);


end




