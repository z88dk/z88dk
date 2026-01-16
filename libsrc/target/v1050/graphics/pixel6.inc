;
;   Visual 1050 pseudo graphics routines
;	Version for the 2x3 graphics symbols (UDG redefined)
;
;       Written by Stefano Bodrato 2025
;
;
;       Plot / unplot / detect pixel at (x,y) coordinate.
;
;
;	$Id: pixel6.inc $
;


    INCLUDE "classic/gfx/grafix.inc"

    EXTERN  div3
    EXTERN  __gfx_coords
    EXTERN	base_graphics

    EXTERN  generic_console_printc


    ld      a, h
    cp      _GFX_MAXX
    ret     nc
    ld      a, l
    cp      _GFX_MAXY
    ret     nc                          ; y0	out of range
    ;inc     a

;    dec     a
;    dec     a

IF  !NEEDpoint
    ld      (__gfx_coords), hl
ENDIF

    push    bc

    ld      c, a                        ; y
    ld      b, h                        ; x

    push    bc


; IF  !NEEDpoint
; push hl
; push de
; extern v1050_sendchar
;     ld      l, 27
;     call    v1050_sendchar
;     ld      l, ')'
;     call    v1050_sendchar
;     ld      l, '2'                      ; Select G2 for the extended font (pseudo-graphics)
;     call    v1050_sendchar
; pop de
; pop hl	
; ENDIF

    ld      hl, div3
    ld      d, 0
    ld      e, c
    add     hl, de
    ld      a, (hl)                     ; y/3
	
IF  !GFXTEXT3
    srl     b                           ; x/2
ENDIF

    ld      hl, (base_graphics)
    ld      c, b                        ; x/2
    ld      b, a                        ; y/3

;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    push    bc                          ; c,b = x,y text position

    and     a                           ; a = b = y/3 (text rows)

    jr      z, r_zero

IF  GFXTEXT3
    ld      de, _GFX_MAXX
ELSE
    ld      de, _GFX_MAXX/2                  ; 80 columns
ENDIF

r_loop:
    add     hl, de
    djnz    r_loop

r_zero:
    ld      d, 0                        ; x position in text buffer
    ld      e, c
    add     hl, de
    ld      a, (hl)                     ; get current symbol from screen

    pop    bc                          ; c,b = x,y text position
	pop    hl
	push   bc

;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

; TODO: symbol remapping for GFXTEXT3 mode


    cp      128
    jr      nc, noblank
    ld      a, 128
noblank:
    sub     128
    ld      e, a                        ; ..and its copy

    ld      a, l
;    inc     a
;    inc     a
    sub     b
    sub     b
    sub     b                           ; we get the remainder of y/3

    ld      l, a
	and     3
	
    ld      a, 1                        ; the pixel we want to draw

    jr      z, iszero
    bit     0, l
    jr      nz, is1
IF  !GFXTEXT3
    add     a, a
ENDIF
    add     a, a
is1:
IF  !GFXTEXT3
    add     a, a
ENDIF
    add     a, a
iszero:

IF  !GFXTEXT3
    bit     0, h
    jr      nz, evenrow
;    jr      z, evenrow
    add     a, a                        ; move down the bit
evenrow:
ENDIF


IF  NEEDplot
    or      e
ENDIF

IF  NEEDunplot
    cpl
    and     e
ENDIF

IF  NEEDxor
    xor     e
ENDIF

IF  NEEDpoint
    and     e
    pop     bc
    pop     bc
    ret
ELSE

    add     128

    pop     bc

; c = x
; b = y
; a = character to print
; e = raw

    call    generic_console_printc

    pop     bc
    ret

ENDIF
