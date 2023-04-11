
SECTION rodata_video_vdp

PUBLIC __vdp_mode2_graphics

EXTERN __tms9918_mode2_cls
EXTERN __tms9918_mode2_plot
EXTERN __tms9918_mode2_res
EXTERN __tms9918_mode2_xor
EXTERN __tms9918_mode2_pointxy

__vdp_mode2_graphics:
    defw    __tms9918_mode2_cls
    defw    __tms9918_mode2_plot
    defw    __tms9918_mode2_res
    defw    __tms9918_mode2_xor
    defw    __tms9918_mode2_pointxy
