# Notice

The files in this directory implement the Dark Channel Prior haze-removal
algorithm from:

> Kaiming He, Jian Sun, Xiaoou Tang. *Single Image Haze Removal Using Dark
> Channel Prior.* IEEE TPAMI, 30(12):2341-2353, 2011.

This is a MATLAB implementation originally by **Stephen Tierney**
([sjtrny/Dark-Channel-Haze-Removal](https://github.com/sjtrny/Dark-Channel-Haze-Removal)),
MIT-licensed — see [LICENSE](LICENSE) (copied unmodified from upstream).

Files: `dehaze.m`, `dehaze_fast.m`, `get_dark_channel.m`, `get_atmosphere.m`,
`get_transmission_estimate.m`, `get_radiance.m`, `get_laplacian.m`,
`guided_filter.m`, `window_sum_filter.m`, `gamma_correction.m`,
`adjust_range.m`, `demo.m` — copied as-is, no changes.

The pre/post-processing pipelines built on top of this (`../pipelines/`) and
the evaluation notebooks (`../evaluation/`) are original work for this
project.
