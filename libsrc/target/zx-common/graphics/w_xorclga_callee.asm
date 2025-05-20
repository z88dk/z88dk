
; Faster "Invert area" in TS2068 MODE6
; 2024 rework by Stefano Bodrato
;
; Usage: xorclga(int tlx, int tly, int tlx2, int tly2)

    SECTION code_graphics

    PUBLIC  xorclga_callee
    PUBLIC  _xorclga_callee

    PUBLIC  asm_xorclga

    EXTERN  __zx_screenmode
IF    !FORts2068
    EXTERN  w_xorpixel
    EXTERN  w_area
ENDIF

    EXTERN  w_pixeladdress
    EXTERN  asm_zx_saddrpdown
    EXTERN  inc_x_MODE6
IF    FORts2068|FORzxn
    EXTERN  __gfx_fatpix
ENDIF

    EXTERN  swapgfxbk
    EXTERN  __graphics_end
    INCLUDE "graphics/grafix.inc"


xorclga_callee:
_xorclga_callee:

    pop     af  ; ret addr
    pop     de  ; tly2
    pop     hl  ; tlx2
    exx                                 ; w_xorpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
    pop     de  ; tly1
    pop     hl  ; tlx1
    push    af                          ; ret addr
    exx

asm_xorclga:

    ld      a, (__zx_screenmode)
    and     7
    jp      z,fast_xorclga_m0

IF !FORts2068

IF FORzxn
    cp      6
    jp      z,fast_xorclga
ENDIF

    push    ix
  IF    NEED_swapgfxbk=1
    call    swapgfxbk
  ENDIF
    ld      ix, w_xorpixel
    call    w_area

  IF    NEED_swapgfxbk
    jp      __graphics_end
  ELSE
    pop     ix
    ret
  ENDIF

ENDIF

fast_xorclga_m0:

IF FORts2068 | FORzxn
    ld   (__gfx_fatpix),a
ENDIF

fast_xorclga:


IF    FORts2068|FORzxn
    ld      a, (__gfx_fatpix)
    and     a
    jr      z, not_fatpix
    add     hl, hl
not_fatpix:
ENDIF

;;   TS2068 High Resolution and standard mode
    push    ix
  IF    NEED_swapgfxbk=1
    call    swapgfxbk
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
    ld      a, maxy
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
    ld      a,h
	cpl
	ex      de,hl
    xor     (hl)
    ld      (hl), a
	ex      de,hl
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
    ld      a,(de)
    xor     255
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
    ld      a,h
	cpl
	ex      de,hl
    xor     (hl)
    ld      (hl), a
	ex      de,hl
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


