
SECTION rodata_video_vdp

PUBLIC __vdp_mode3_graphics

EXTERN __tms9918_mode3_cls
EXTERN __tms9918_mode3_plot
EXTERN __tms9918_mode3_res
EXTERN __tms9918_mode3_xor
EXTERN __tms9918_mode3_pointxy

__vdp_mode3_graphics:
    defw    __tms9918_mode3_cls
    defw    __tms9918_mode3_plot
    defw    __tms9918_mode3_res
    defw    __tms9918_mode3_xor
    defw    __tms9918_mode3_pointxy
