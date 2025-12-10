
; Faster "Filled box" in TS2068 MODE6
; 2024 rework by Stefano Bodrato
;
; Usage: fillb(int tlx, int tly, int tlx2, int tly2)

IF FORts2068|FORzxn
    SECTION code_graphics

    PUBLIC  fillb_callee
    PUBLIC  _fillb_callee

    PUBLIC  asm_fillb

    EXTERN  __zx_screenmode
IF    !FORts2068
    EXTERN  w_plotpixel
    EXTERN  w_area
ENDIF

    EXTERN  w_pixeladdress
    EXTERN  asm_zx_saddrpdown
    EXTERN  inc_x_MODE6
IF    FORts2068|FORzxn
    EXTERN  __gfx_fatpix
ENDIF

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"


fillb_callee:
_fillb_callee:

    pop     af  ; ret addr
    pop     de  ; tly2
    pop     hl  ; tlx2
    exx                                 ; w_plotpixel and __gfx_vram_page_in must not use the alternate registers, no problem with w_line_r
    pop     de  ; tly1
    pop     hl  ; tlx1
    push    af                          ; ret addr
    exx

asm_fillb:

    ld      a, (__zx_screenmode)
    and     7
    jp      z,fast_fillb_m0

IF !FORts2068

IF FORzxn
    cp      6
    jp      z,fast_fillb
ENDIF

    push    ix
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    ld      ix, w_plotpixel
    call    w_area

  IF    _GFX_PAGE_VRAM
    jp      __graphics_end
  ELSE
    pop     ix
    ret
  ENDIF

ENDIF

fast_fillb_m0:

IF FORts2068 | FORzxn
    ld   (__gfx_fatpix),a
ENDIF

fast_fillb:


IF    FORts2068|FORzxn
    ld      a, (__gfx_fatpix)
    and     a
    jr      z, not_fatpix
    add     hl, hl
not_fatpix:
ENDIF

;;   TS2068 High Resolution and standard mode
    push    ix
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF

    ld      a,e          ; height
    push    hl           ; width
    exx  ; hl=x
         ; de=y
    pop     bc           ; width
    ld      ixl, a       ; height (ix forgotten)

    ld      a, 1
    cp      h
    jp      c, __graphics_end
    ld      a, _GFX_MAXY
    cp      e
    jp      c, __graphics_end

    push    bc
    call    w_pixeladdress
    ld      b, a
    ld      a, 1
    jr      z, next
loop:
    rlca
    djnz    loop
next:
    cpl
    ld      l, a
    pop     bc
outer_loop:
    push    bc            ; 1 (width)
    push    de            ; 2 (height)
    ld      a, l
    ld      h, l
    cp      127
    jr      z, fill1
inner_loop0:
    ld      a, (de)
    cpl
    and     h
    cpl
    ld      (de), a
    dec     bc
    rrc     h
    jr      nc, fill
    ld      a, b
    or      c
    jr      nz, inner_loop0
fill:

    call    inc_x_MODE6

    jr      c, wypad
fill1:
    push    bc
    srl     b                           ; >> 3
    rr      c
    srl     c
    srl     c
    ld      a, c
    or      c
    ld      b, c
    jr      z, last

inner_loop1:
    ld      a,255
    ld      (de), a
    call    inc_x_MODE6
    jr      c, wypad
    djnz    inner_loop1

last:
    pop     bc                          ; 3
    ld      a, c
    and     7
    jr      z, wypad
    ld      b, a
inner_loop2:
    ld      a, (de)
    cpl
    and     h
    cpl
    ld      (de), a
    rrc     h
    jr      nc, wypad
    djnz    inner_loop2

wypad:
    pop     de                          ; 2
    pop     bc                          ; 1
    dec     ixl
    jp      z, __graphics_end
    ex      de,hl
    call    asm_zx_saddrpdown
    ex      de,hl
    jp      c, __graphics_end
    jr      outer_loop

ENDIF
