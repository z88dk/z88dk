
SECTION rodata_video_vdp

PUBLIC  __vdp_mode5_graphics

EXTERN  __v9938_mode5_cls
EXTERN  __v9938_plot
EXTERN  __v9938_res
EXTERN  __v9938_xor
EXTERN  __v9938_pointxy

__vdp_mode5_graphics:
    defw    __v9938_mode5_cls
    defw    __v9938_plot
    defw    __v9938_res
    defw    __v9938_xor
    defw    __v9938_pointxy
