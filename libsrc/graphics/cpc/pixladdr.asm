
        SECTION   code_clib
        PUBLIC	pixeladdress

        INCLUDE "cpcfirm.def"
        INCLUDE	"graphics/grafix.inc"

;
;	$Id: pixladdr.asm,v 1.9 2016-06-19 21:10:08 dom Exp $
;

; ******************************************************************
;
; Get absolute	pixel address in map of virtual (x,y) coordinate.
;
; in:  hl	= (x,y) coordinate of pixel (h,l)
;
; out: de	= address	of pixel byte
;	   a	= bit number of byte where pixel is to be placed
;	  fz	= 1 if bit number is 0 of pixel position
;
; registers changed	after return:
;  ......hl/ixiy same
;  afbcde../.... different
;


; We use the Amstrad ROM function
;
;095   &BC1D   SCR DOT POSITION
;      Action: Gets the memory  address  of  a  pixel  at  a specified
;              screen position
;      Entry:  DE contains the base X-coordinate  of the pixel, and HL
;              contains the base Y-coordinate
;      Exit:   HL contains the memory address of the pixel, C contains
;              the bit mask for this  pixel,  B contains the number of
;              pixels stored in a byte minus 1, AF and DE are corrupt,
;              and all others are preserved

	PUBLIC	grayaltpage


.pixeladdress
        push	bc
        ld      a,maxy
        sub     l	
        ld      d,0
        ld      e,h
        ld      h,d
        ld      l,a
        call    firmware
        defw    scr_dot_position
        ld      d,h
        ld      e,l
        ld      a,c
        ld      c,-1
.loopa  inc     c
        rra
        jr      nc,loopa
        ld      a,c

.grayaltpage
        nop
        pop     bc
        ret

