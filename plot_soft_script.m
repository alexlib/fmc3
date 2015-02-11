% run_soft_script

base_dir = '/Users/matthewgiarra/Desktop/soft_test';

is_real = 1;

% Data type
data_type = 'volumes_02';

data_dir   = fullfile(base_dir, 'data_files', data_type, 'raw');   
corr_dir = fullfile(base_dir, 'data_files', data_type, 'corr'); 
plot_dir   = fullfile(base_dir, 'data_files', data_type, 'plot');  

band_width_in  = 64;
band_width_out = 32;

% Max order of transforms
max_order = 7;

start_file = 1;
end_file = 100;
skip_file = 1;

file_base = 'input_data_sph_proj_';
file_ext = '.dat';
n_digits = 3;
num_format = ['%0' num2str(n_digits) 'd'];

% Output file base
corr_file_base = 'vol_corr_';

% Make the output dir if it doesn't exist
if ~exist(plot_dir, 'dir');
    mkdir(plot_dir)
end

% List of file numbers
file_nums = start_file : skip_file : end_file;

% Number of files
num_files = length(file_nums);

close all

% Loop over all the files
for k = 1 : num_files
   
    cla;
    
    % Output file name and path
    results_file_name = [corr_file_base, ...
        num2str(file_nums(1), num_format), '_' ...
        num2str(file_nums(k), num_format), file_ext];
    results_file_path = fullfile(corr_dir, results_file_name);
    
    % Plot file name
    plot_file_name = [corr_file_base, ...
        num2str(file_nums(1), num_format), '_' ...
        num2str(file_nums(k), num_format), '.png'];
    plot_file_path = fullfile(plot_dir, plot_file_name);

    C = read_soft_results_file(results_file_path, band_width_out, is_real);
    
    plot_soft_correlation(C);
    
    alphamap('decrease', 0.5);
%     set(gca, 'cameraposition', [-4.0124,  -14.6440,    2.7450]);
    
    set(gcf, 'inverthardcopy', 'off');
    
    print(1, '-dpng', '-r300', plot_file_path);
    
    
    
end










