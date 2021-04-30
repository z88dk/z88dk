;
;      Z88 Graphics Functions - Small C+ stubs
;
;      Stefano Bodrato 19/7/2007
; Usage: multipoint(int hv, int length, int x, int y)

IF !__CPU_INTEL__ && !__CPU_GBZ80__
    SECTION code_graphics
    PUBLIC  multipoint
    PUBLIC  _multipoint

    EXTERN  asm_multipoint
    INCLUDE "graphics/grafix.inc"


.multipoint
._multipoint
    pop     af    ; ret addr
    pop     de    ; y
    pop     hl    ; x
    pop     bc
    ex      af,af
    ld      a,c    ; length
    pop     bc    ; h/v
    ld      b,a
    ex      af,af
    push    de
    push    de
    push    de
    push    de
    push    af    ; ret addr
    jp      asm_multipoint
ENDIF
