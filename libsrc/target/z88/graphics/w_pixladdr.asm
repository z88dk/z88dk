    SECTION code_clib
    PUBLIC  w_pixeladdress

    EXTERN  base_graphics
    EXTERN  __z88_gfxmode


    EXTERN  w_pixeladdress_MODE0


;
;	$Id: pixladdr.asm,v 1.7 2016-04-23 21:05:46 dom Exp $
;

; ******************************************************************
;
; Get absolute	pixel address in map of virtual (x,y) coordinate.
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; in:  hl,de	= (x,y) coordinate of pixel (hl,de)
;
; out: de	= address	of pixel byte
;	   a	= bit number of byte where pixel is to be placed
;	  fz	= 1 if bit number is 0 of pixel position
;
; registers changed	after return:
;  ......../ixiy same
;  afbcdehl/.... different
;
w_pixeladdress:
    ld      a,(__z88_gfxmode)
    and     a
    jr      z,pixeladdress
    cp      2
    jp      z,w_pixeladdress_MODE0

    ;; This is for 512 
    ld      a,e
    rrca
    rrca
    and     @00001110
    ld      b,a         ; llinedist = (y	div 8) * 512

    ld      a, l
    and     @11111000                   ; rowdist	= x div 8	* 8
    ld      c, a                        ; bc	= linedist + rowdist

    ; If we're over 256 pixels, then add 256 bytes
    rr      h
    ld      a,0
    adc     b
    ld      b,a

    ld      a, e
    and     @00000111                   ; coldist	= y mod 8
    ld      de, (base_graphics)         ; pointer	to base of graphics	area
    ld      e, a                        ; coldist	= graphicsarea	+ coldist

    ld      a, l
    ex      de, hl
    add     hl, bc                      ; bytepos	= linedist + rowdist + coldist
    ex      de, hl
    and     @00000111                   ; a = x mod 8
    xor     @00000111                   ; a = 7 -	a
    ret


pixeladdress:
    ld      h,l
    ld      l,e
    ; in:  hl	= (x,y) coordinate of pixel (h,l)
    ld      a,l
    rrca
    rrca
    rrca
    and     @00000111
    ld      b,a         ; llinedist = (y	div 8) * 256
    ld      a, h
    and     @11111000                   ; rowdist	= x div 8	* 8
    ld      c, a                        ; bc	= linedist + rowdist
    ld      a, l
    and     @00000111                   ; coldist	= y mod 8
    ld      de, (base_graphics)         ; pointer	to base of graphics	area
    ld      e, a                        ; coldist	= graphicsarea	+ coldist
    ld      a, h
    ex      de, hl
    add     hl, bc                      ; bytepos	= linedist + rowdist + coldist
    ex      de, hl
    and     @00000111                   ; a = x mod 8
    xor     @00000111                   ; a = 7 -	a
    ret
