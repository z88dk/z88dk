

SECTION rodata_video_vdp
PUBLIC  __vdp_mode8_term

EXTERN __v9938_mode8_cls
EXTERN  __v9938_mode8_printc
EXTERN  __v9938_mode8_scroll
EXTERN  l_ret

__vdp_mode8_term:
    defw     __v9938_mode8_cls
    defw     __v9938_mode8_printc
    defw     __v9938_mode8_scroll

