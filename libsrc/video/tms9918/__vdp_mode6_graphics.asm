
SECTION rodata_video_vdp

PUBLIC  __vdp_mode6_graphics

EXTERN  __v9938_mode6_cls
EXTERN  __v9938_x2_plot
EXTERN  __v9938_x2_res
EXTERN  __v9938_x2_xor
EXTERN  __v9938_x2_pointxy

__vdp_mode6_graphics:
    defw    __v9938_mode6_cls
    defw    __v9938_x2_plot
    defw    __v9938_x2_res
    defw    __v9938_x2_xor
    defw    __v9938_x2_pointxy
