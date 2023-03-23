

SECTION rodata_video_vdp
PUBLIC __vdp_mode3_term

EXTERN  FILVRM
EXTERN  __tms9918_pattern_generator
EXTERN __tms9918_mode3_cls
EXTERN  l_ret

__vdp_mode3_term:
    defw    __tms9918_mode3_cls
    defw    l_ret
    defw    l_ret


