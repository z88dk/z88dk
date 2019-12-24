
        SECTION   code_clib
        PUBLIC	w_pixeladdress
		
		EXTERN	cpc_GetScrAddress0

        ;INCLUDE "target/cpc/def/cpcfirm.def"
        INCLUDE	"graphics/grafix.inc"

;
;	$Id: w_pixeladdress.asm $
;

; ******************************************************************
;
; Get absolute	pixel address in map of virtual (x,y) coordinate.
;
; in:  hl,de    = (x,y) coordinate of pixel
;
; out: de	= address	of pixel byte
;	   a	= bit number of byte where pixel is to be placed
;	  fz	= 1 if bit number is 0 of pixel position
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

;	PUBLIC	grayaltpage


.w_pixeladdress

		ld	a,l
        and     07h             ;a = x mod 8
		push af
		
;		push hl
;        ld      hl,maxy-1
;        sbc		hl,de
;		pop		de
		
		srl h
		rr l
		srl h
		rr l
		srl h
		rr l
		ld	a,l
		ld	l,e
		call	cpc_GetScrAddress0
;        call    firmware
;        defw    scr_dot_position
        ld      d,h
        ld      e,l

		pop		af        
        xor     7
        ret

