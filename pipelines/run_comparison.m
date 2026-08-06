function results = run_comparison(image_dir, output_dir)
%RUN_COMPARISON  Run all 5 dehazing pipelines over every .jpg in IMAGE_DIR.
%
%   RESULTS = RUN_COMPARISON(IMAGE_DIR, OUTPUT_DIR) applies each of the 5
%   pipelines in apply_pipeline.m to every image in IMAGE_DIR, scores each
%   result against the original image with MSE/SSIM/PSNR, writes the
%   processed images to OUTPUT_DIR (default: 'results/'), and returns a
%   table with one row per (image, method) pair. The table is also written
%   to OUTPUT_DIR/results.csv.
%
%   NOTE ON THE METRICS: MSE/SSIM/PSNR are computed against each image's
%   own original (hazy) version, not a haze-free ground truth - none was
%   available for this dataset. They measure how much a pipeline changes
%   the image relative to the others, not absolute dehazing accuracy.
%   This is inherited unchanged from the project's original per-method
%   scripts (method1.m .. method5.m).
%
%   See also: apply_pipeline

if nargin < 2
    output_dir = 'results';
end
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

files = dir(fullfile(image_dir, '*.jpg'));
n_methods = 5;

image_col = {};
method_col = [];
mse_col = [];
ssim_col = [];
psnr_col = [];

for i = 1:numel(files)
    x = imread(fullfile(image_dir, files(i).name));
    ref = double(x);
    [~, name, ~] = fileparts(files(i).name);

    for m = 1:n_methods
        out = apply_pipeline(x, m);

        image_col{end + 1, 1}  = files(i).name;
        method_col(end + 1, 1) = m;
        mse_col(end + 1, 1)    = immse(ref, double(out));
        ssim_col(end + 1, 1)   = ssim(out, ref);
        psnr_col(end + 1, 1)   = psnr(out, ref);

        imwrite(uint8(out), fullfile(output_dir, sprintf('%s_method%d.jpg', name, m)));
    end
end

results = table(image_col, method_col, mse_col, ssim_col, psnr_col, ...
    'VariableNames', {'Image', 'Method', 'MSE', 'SSIM', 'PSNR'});

writetable(results, fullfile(output_dir, 'results.csv'));
disp(results);

end
