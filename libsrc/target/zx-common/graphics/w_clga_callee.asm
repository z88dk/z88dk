
; "Clear area" on the TS2068
; 2024 rework by Stefano Bodrato
;
; Usage: clga(int tlx, int tly, int tlx2, int tly2)

    SECTION code_graphics

    PUBLIC  clga_callee
    PUBLIC  _clga_callee

    PUBLIC  asm_clga

IF    FORzxn
    EXTERN  __zx_screenmode
    EXTERN  w_respixel
    EXTERN  w_area
ENDIF

    EXTERN  swapgfxbk
    EXTERN  __graphics_end
    EXTERN  w_pixeladdress
    INCLUDE "graphics/grafix.inc"


clga_callee:
_clga_callee:

    pop     af  ; ret addr
    pop     de  ; tly2
    pop     hl  ; tlx2
    exx                                 ; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
    pop     de  ; tly1
    pop     hl  ; tlx1
    push    af                          ; ret addr
    exx

asm_clga:

IF    FORzxn

    ld      a, (__zx_screenmode)
    cp      6
    jp      z,w_area_ts2068

    push    ix
  IF    NEED_swapgfxbk=1
    call    swapgfxbk
  ENDIF
    ld      ix, w_respixel
    call    w_area

  IF    NEED_swapgfxbk
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF

w_area_ts2068:
ELSE


;;   TS2068 High Resolution mode
    push    ix
  IF    NEED_swapgfxbk=1
    call    swapgfxbk
  ENDIF

    push    hl           ; width
    ld      a,e          ; height
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
    and     h
    ld      (de), a
    dec     bc
    rrc     h
    jr      nc, fill
    ld      a, b
    or      c
    jr      nz, inner_loop0
fill:
    call    INC_X
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
    xor     a
    ld      (de), a
    call    INC_X
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
    and     h
    ld      (de), a
    rrc     h
    jr      nc, wypad
    djnz    inner_loop2

wypad:
    pop     de                          ; 2
    pop     bc                          ; 1
    dec     ixl
    jp      z, __graphics_end
    call    incy
    jp      c, __graphics_end
    jr      outer_loop


; (hl) mask
; de - screen address
INC_X:
    bit     5, d
    jr      nz, first
    set     5, d
    or      a
    ret
first:
    res     5, d
    inc     e
    ld      a, e
    and     $1f
    ret     nz
    scf
    ret

incy:
    inc     d
    ld      a, d
    and     $07
    ret     nz

    ld      a, d
    sub     $08
    ld      d, a
    ld      a, e
    add     a, $20
    ld      e, a
    ret     nc

    ld      a, d
    add     a, $08
    ld      d, a

    and     95
    cp      $58
    ccf
    ret
ENDIF
