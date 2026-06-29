

    SECTION code_graphics
    PUBLIC  w_pixeladdress

    INCLUDE "classic/gfx/grafix.inc"
;
;       $Id: w_pixladdr.asm $
;
; ******************************************************************
; Get absolute  pixel address in map of virtual (x,y) coordinate.
; in: (x,y) coordinate of pixel (hl,de)
;

;
; out: de = hl    = address of pixel byte
;      a          = bit number of byte where pixel is to be placed
;      fz         = 1 if bit number is 0 of pixel position
;
; registers changed     after return:
;  ..bc..../ixiy same
;  af..dehl/.... different


; Northstar Advantage needs two memory pages, a big 16K one and a 4K slice for the rightmost display portion.
; It is organized in 80 columnns of 256 bytes each, only 240 are visible at once (depending on the scroll register at address 090h).

; The graphics pages are enabled with:
; LD A,80h   (or 81H for the right 16 columns display slice)
; OUT (0A1h),A

; To page out the graphics banks:
; XOR A
; OUT (0A1h),A

; On the so called graphics CP/M this should page in/out a 16K memory section at 16384

w_pixeladdress:

    ; HL = x, DE = y
    
    push    bc

    ; save x for bit index
    ld      a,l
    push    af

    ld      a,h
    sub     2

    ld      a,0x81
    jr      nc,right_side

    dec     a

right_side:
    out     (0xA1),a


    ; --- compute x / 8
    ld      a,h
    or      2
    srl     a
    rr      l
    srl     a
    rr      l
    srl     a
    rr      l          ; HL = x/8

    ; --- HL = (x/8) * 256
    ld      h,l
    ld      l,0

    ; Add  Y
    add     hl, de

    ; return in DE also
    ld      d, h
    ld      e, l

    ; --- bit calc
    pop     af
    and     @00000111
    xor     @00000111
    pop     bc

    ret
