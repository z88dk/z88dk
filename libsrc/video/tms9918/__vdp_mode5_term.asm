

SECTION rodata_video_vdp
PUBLIC  __vdp_mode5_term

EXTERN __v9938_mode5_cls
EXTERN  __v9938_mode5_printc
EXTERN  __v9938_mode5_scroll
EXTERN  l_ret

__vdp_mode5_term:
    defw     __v9938_mode5_cls
    defw     __v9938_mode5_printc
    defw     __v9938_mode5_scroll

