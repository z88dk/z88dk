

SECTION rodata_video_vdp
PUBLIC  __vdp_mode6_term

EXTERN  __v9938_mode6_cls
EXTERN  __v9938_mode6_printc
EXTERN  __v9938_mode6_scroll

__vdp_mode6_term:
    defw     __v9938_mode6_cls
    defw     __v9938_mode6_printc
    defw     __v9938_mode6_scroll

