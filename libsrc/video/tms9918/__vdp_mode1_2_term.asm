; Console table for mangled mode 1+2


SECTION rodata_video_vdp
PUBLIC __vdp_mode1_2_term

EXTERN  __tms9918_pattern_generator
EXTERN  FILVRM
EXTERN  l_ret

__vdp_mode1_2_term:
    defw    mode_1_2_cls ;cls
    defw    l_ret        ;printc
    defw    l_ret        ;scroll

SECTION code_video_vdp

mode_1_2_cls:
    ld      hl,(__tms9918_pattern_generator)
    ld      bc,6144
    xor     a
    jp      FILVRM

