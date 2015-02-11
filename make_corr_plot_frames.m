function make_corr_plot_frames(CORRELATION_VALUES);

% Number of frames
num_frames = 40;
save_dir = '~/Desktop/corr_plots_02';

alpha_map_delta = 1 / num_frames;

plot_soft_correlation(CORRELATION_VALUES);

set(gcf, 'inverthardcopy', 'off');

for k = 1 : num_frames
    
    file_name = ['image_' num2str(k, '%03.0f')];
    file_path = fullfile(save_dir, file_name);
    alphamap('decrease', alpha_map_delta);
    print(1, '-dpng', '-r300', file_path);
    
end

end