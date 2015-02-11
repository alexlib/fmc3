% run_soft_script

base_dir = '/Users/matthewgiarra/Desktop/soft_test';

this_dir = pwd;

% Data type
data_type = 'volumes_02';

data_dir = fullfile(base_dir, 'data_files', data_type, 'raw');
output_dir = fullfile(base_dir, 'data_files', data_type, 'corr');


fun_name = 'test_soft_fftw_correlate2';
fun_path = fullfile(base_dir, fun_name);

band_width_in  = 64;
band_width_out = 32;

% Max order of transforms
max_order = 7;

start_file = 1;
end_file = 100;
skip_file = 1;

file_base = 'input_data_vol_';
file_ext = '.dat';
n_digits = 3;
num_format = ['%0' num2str(n_digits) 'd'];

% Output file base
output_file_base = 'vol_corr_';

% Make the output dir if it doesn't exist
if ~exist(output_dir, 'dir');
    mkdir(output_dir)
end

% List of file numbers
file_nums = start_file : skip_file : end_file;

% Number of files
num_files = length(file_nums);

file_name_01 = [file_base num2str(file_nums(1), num_format) file_ext];
file_path_01 = fullfile(data_dir, file_name_01);

% Loop over all the files
for k = 1 : num_files
   
    cd(base_dir);
    
    % File name and path
    file_name_02 = [file_base num2str(file_nums(k), num_format) file_ext];
    file_path_02 = fullfile(data_dir, file_name_02);
    
    % Output file name and path
    output_file_name = [output_file_base, ...
        num2str(file_nums(1), num_format), '_' ...
        num2str(file_nums(k), num_format), file_ext];
    output_file_path = fullfile(output_dir, output_file_name);
    
    % Build the command to run
    cmd = ['!./' fun_name ' ' file_path_01 ' ' file_path_02, ...
        ' ' num2str(band_width_in) ' ' num2str(band_width_out), ...
        ' ' num2str(max_order) ' ' output_file_path];
    
    eval(cmd);
    
    cd(this_dir);
    
end










