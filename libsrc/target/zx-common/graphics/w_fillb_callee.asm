
; Faster "Filled box" in TS2068 MODE6
; 2024 rework by Stefano Bodrato
;
; Usage: fillb(int tlx, int tly, int tlx2, int tly2)

    SECTION code_graphics

    PUBLIC  fillb_callee
    PUBLIC  _fillb_callee

    PUBLIC  asm_fillb

    EXTERN  __zx_screenmode
    EXTERN  w_plotpixel
    EXTERN  w_area

    EXTERN  w_pixeladdress
    EXTERN  inc_y_MODE6
IF    FORts2068|FORzxn
    EXTERN  inc_x_MODE6
    EXTERN  __gfx_fatpix
ENDIF

    EXTERN  swapgfxbk
    EXTERN  __graphics_end
    INCLUDE "graphics/grafix.inc"


fillb_callee:
_fillb_callee:

    pop     af  ; ret addr
    pop     de  ; tly2
    pop     hl  ; tlx2
    exx                                 ; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
    pop     de  ; tly1
    pop     hl  ; tlx1
    push    af                          ; ret addr
    exx

asm_fillb:

    ld      a, (__zx_screenmode)
    and     7
    jp      z,fast_fillb
IF    FORts2068|FORzxn
    cp      6
    jp      z,fast_fillb
ENDIF


    push    ix
  IF    NEED_swapgfxbk=1
    call    swapgfxbk
  ENDIF
    ld      ix, w_plotpixel
    call    w_area

  IF    NEED_swapgfxbk
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF


fast_fillb:
;;   TS2068 High Resolution and standard mode
    push    ix
  IF    NEED_swapgfxbk=1
    call    swapgfxbk
  ENDIF

IF    FORts2068|FORzxn
    ld      a, (__gfx_fatpix)
    and     a
    ld      a,e          ; height
    jr      z, not_fatpix
    add     hl, hl
not_fatpix:
ENDIF
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

    call    next_column

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
    call    next_column
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
    call    inc_y_MODE6
    jp      c, __graphics_end
    jr      outer_loop


next_column:
    ex      af,af
IF    FORts2068|FORzxn
    ld      a, (__zx_screenmode)
    and     a
    jr      z,_mode0
    call    inc_x_MODE6
    ex      af,af
    jr      _mode6
_mode0:
ENDIF
    inc     de
_mode6:
    ex      af,af
	ret

