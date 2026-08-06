function out = apply_pipeline(x, method)
%APPLY_PIPELINE  Run one of five haze-removal pre/post-processing combos.
%
%   OUT = APPLY_PIPELINE(X, METHOD) dehazes the RGB image X (uint8) using
%   the dark-channel-prior algorithm (dehaze_fast, see ../dehazing/),
%   wrapped with one of five pre/post-processing combinations selected by
%   METHOD (integer, 1-5):
%
%     1: Gamma correction -> DCP -> Unsharp masking
%     2: Histogram equalization -> Laplacian sharpening -> DCP
%     3: Gamma correction -> DCP -> Histogram equalization -> Unsharp masking
%     4: Per-channel CLAHE (RGB + HSV, additively recombined) -> Gamma
%        correction -> DCP -> Unsharp masking
%     5: Gamma correction -> DCP -> Laplacian sharpening
%
%   This project's original comparison ran these five combinations as five
%   separate, near-identical copy-pasted scripts (method1.m .. method5.m);
%   this function consolidates them into one, parameterized by METHOD, with
%   the exact same operations and parameters as the originals.
%
%   See also: run_comparison, dehaze_fast

laplacian_kernel = [0, 1, 0; 1, -4, 1; 0, 1, 0];

switch method
    case 1
        y = gamma_correction(x, [0 1], [0 1], 0.2);
        result = dehaze_fast(y, 0.95, 5);
        out = imsharpen(result);

    case 2
        equalized = histeq(x);
        sharpened = double(equalized - 0.8 .* imfilter(equalized, laplacian_kernel, 'replicate'));
        out = dehaze_fast(sharpened, 0.95, 5);

    case 3
        y = gamma_correction(x, [0 1], [0 1], 0.2);
        result = histeq(dehaze_fast(y, 0.95, 5));
        out = imsharpen(result);

    case 4
        red   = adapthisteq(x(:, :, 1));
        green = adapthisteq(x(:, :, 2));
        blue  = adapthisteq(x(:, :, 3));

        hsv = rgb2hsv(x);
        h = hsv(:, :, 1);
        s = adapthisteq(hsv(:, :, 2));
        v = adapthisteq(hsv(:, :, 3));

        recombined_rgb = cat(3, red, green, blue);
        recombined_hsv = uint8(cat(3, h, s, v));
        enhanced = recombined_rgb + recombined_hsv;

        y = gamma_correction(enhanced, [0 1], [0 1], 0.2);
        result = dehaze_fast(y, 0.95, 5);
        out = imsharpen(result);

    case 5
        y = gamma_correction(x, [0 1], [0 1], 0.2);
        result = dehaze_fast(y, 0.95, 5);
        out = result - 0.5 .* imfilter(result, laplacian_kernel, 'replicate');

    otherwise
        error('apply_pipeline:badMethod', 'method must be an integer 1-5, got %g', method);
end

end
