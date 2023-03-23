

SECTION code_video_vdp
PUBLIC  __tms9918_clear_vram

EXTERN  FILVRM

__tms9918_clear_vram:
    ld      hl,0
    ld      bc,16384
    xor     a
    jp      FILVRM
