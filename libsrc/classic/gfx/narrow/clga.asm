;Usage: clga(int tlx, int tly, int tlx2, int tly2)

    SECTION code_graphics

    PUBLIC  clga
    PUBLIC  _clga
    PUBLIC  ___clga

    EXTERN  asm_clga

clga:
_clga:
___clga:

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
    ld      ix, 2
    add     ix, sp
    ld      c, (ix+2)
    ld      b, (ix+4)
    ld      l, (ix+6)
    ld      h, (ix+8)
    pop     ix
ELSE
    pop     af
    pop     bc                          ; height
    pop     de
    ld      b, e                        ; width
    pop     hl                          ; x
    pop     de
    push    de
    push    hl
    ld      h, e                        ; y
    push    de                          ; this value is lost
    push    bc
    push    af
ENDIF

    jp      asm_clga
