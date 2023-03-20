

SECTION code_clib
PUBLIC  __tms9918_clear_vram

EXTERN  FILVRM

__tms9918_clear_vram:
    ld      hl,0
    ld      bc,16384
    xor     a
    call    FILVRM
    ret
