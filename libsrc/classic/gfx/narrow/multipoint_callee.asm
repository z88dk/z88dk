;
;     Z88 Graphics Functions - Small C+ stubs
;
;     Stefano Bodrato 19/7/2007
;
;
;     $Id: multipoint_callee.asm $
;


IF  !__CPU_INTEL__&!__CPU_GBZ80__
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- bool  multipoint(int hv, int length, int x, int y)

;Usage:
;pick a vertical or horizontal bit bar, up to 16 bits long


    SECTION code_graphics
    PUBLIC  multipoint_callee
    PUBLIC  _multipoint_callee
    PUBLIC  asm_multipoint

    EXTERN  pointxy
    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out
    INCLUDE "classic/gfx/grafix.inc"


multipoint_callee:
_multipoint_callee:

    pop     af                          ; ret addr
    pop     hl                          ; y
    pop     de                          ; x
    ld      h, e
    pop     bc
    ld      b, c                        ; length
    pop     de
    ld      c, e                        ; h/v
    push    af                          ; ret addr
asm_multipoint:
    push    ix
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    ld      de, 0
    rr      c
    jr      nc, horizontal
vertical:
    sla     e
    rl      d
    push    de
    push    hl
    push    bc
    call    pointxy
    pop     bc
    pop     hl
    pop     de
    jr      z, jv
    inc     de
jv:
    inc     l
    djnz    vertical
    jr      exit
horizontal:
    sla     e
    rl      d
    push    de
    push    hl
    push    bc
    call    pointxy
    pop     bc
    pop     hl
    pop     de
    jr      z, jh
    inc     de
jh:
    inc     h
    djnz    horizontal
exit:
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_out
  ENDIF
    pop     ix
    ld      h, d
    ld      l, e
    ret


ENDIF
