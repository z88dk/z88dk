
SECTION rodata_video_vdp

PUBLIC  __vdp_mode8_graphics

EXTERN  __v9938_mode8_cls
EXTERN  __v9938_mode8_plot
EXTERN  __v9938_mode8_res
EXTERN  __v9938_mode8_xor
EXTERN  __v9938_mode8_pointxy

__vdp_mode8_graphics:
    defw    __v9938_mode8_cls
    defw    __v9938_mode8_plot
    defw    __v9938_mode8_res
    defw    __v9938_mode8_xor
    defw    __v9938_mode8_pointxy
