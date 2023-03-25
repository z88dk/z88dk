

SECTION rodata_video_vdp
PUBLIC  __vdp_mode5_term

EXTERN __tms9918_mode5_cls
EXTERN  __tms9918_mode5_printc
EXTERN  l_ret

__vdp_mode5_term:
    defw     __tms9918_mode5_cls
    defw     __tms9918_mode5_printc
    defw     l_ret

