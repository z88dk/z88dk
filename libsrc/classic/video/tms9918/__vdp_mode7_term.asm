

    SECTION rodata_video_vdp
    PUBLIC  __vdp_mode7_term

    EXTERN  __v9938_mode7_cls
    EXTERN  __v9938_mode7_printc
    EXTERN  __v9938_mode7_scroll

__vdp_mode7_term:
    defw    __v9938_mode7_cls
    defw    __v9938_mode7_printc
    defw    __v9938_mode7_scroll

