; ----- bool  multipoint(int hv, int length, int x, int y)

;Usage:
;pick a vertical or horizontal bit bar, up to 16 bits long


IF  !__CPU_INTEL__&&!__CPU_GBZ80__
    SECTION code_graphics
    PUBLIC  multipoint_callee
    PUBLIC  _multipoint_callee
    PUBLIC  asm_multipoint

    EXTERN  w_pointxy

    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out
    INCLUDE "classic/gfx/grafix.inc"


multipoint_callee:
_multipoint_callee:
    pop     af                          ; ret addr
    pop     de                          ; y
    pop     hl                          ; x
    pop     bc
    ex      af, af
    ld      a, c                        ; length
    pop     bc                          ; h/v
    ld      b, a
    ex      af, af
    push    af                          ; ret addr


asm_multipoint:

    push    ix
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF
    ld      a, b
    rr      c
    ld      bc, 0

    jr      nc, horizontal
vertical:
    sla     c
    rl      b
    push    af
    push    hl
    push    de
    push    bc
    call    w_pointxy
    pop     bc
    pop     de
    pop     hl
    jr      z, jv
    inc     bc
jv:
    pop     af
    inc     de
    dec     a
    jr      nz, vertical
    jr      exit

horizontal:
    sla     c
    rl      b
    push    af
    push    hl
    push    de
    push    bc
    call    w_pointxy
    pop     bc
    pop     de
    pop     hl
    jr      z, jh
    inc     bc
jh:
    pop     af
    inc     hl
    dec     a
    jr      nz, horizontal
exit:
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_out
  ENDIF
    pop     ix
    ld      h, b
    ld      l, c
    ret
ENDIF
