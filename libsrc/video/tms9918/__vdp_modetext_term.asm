; Mode 0 + mode 1 have hte same terminal spec

SECTION rodata_video_vdp
PUBLIC __vdp_modetext_term

EXTERN  __tms9918_text_cls
EXTERN  __tms9918_text_printc
EXTERN  __tms9918_text_scroll

__vdp_modetext_term:
    defw     __tms9918_text_cls
    defw     __tms9918_text_printc
    defw     __tms9918_text_scroll



