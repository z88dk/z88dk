

SECTION rodata_video_vdp
PUBLIC __vdp_mode2_term

EXTERN  __tms9918_mode2_cls
EXTERN  __tms9918_mode2_printc
EXTERN  ansi_SCROLLUP

__vdp_mode2_term:
    defw     __tms9918_mode2_cls
    defw     __tms9918_mode2_printc
    defw     ansi_SCROLLUP

