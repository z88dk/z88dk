

SECTION code_video_vdp
PUBLIC  __tms9918_clear_vram

EXTERN  FILVRM

__tms9918_clear_vram:
IFDEF V9938
    ld      bc,65536
ELSE
    ld      bc,16384
ENDIF
    ld      hl,0
    xor     a
    jp      FILVRM
