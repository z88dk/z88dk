
    SECTION rodata_video_vdp

    PUBLIC  __vdp_mode7_graphics

    EXTERN  __v9938_mode7_cls
    EXTERN  __v9938_mode7_plot
    EXTERN  __v9938_mode7_res
    EXTERN  __v9938_mode7_xor
    EXTERN  __v9938_mode7_pointxy

__vdp_mode7_graphics:
    defw    __v9938_mode7_cls
    defw    __v9938_mode7_plot
    defw    __v9938_mode7_res
    defw    __v9938_mode7_xor
    defw    __v9938_mode7_pointxy
