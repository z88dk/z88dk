
	XLIB	pixeladdress

	INCLUDE	"graphics/grafix.inc"

	XREF	base_graphics

;
;	$Id: pixladdr.asm,v 1.5 2002-04-17 21:30:25 dom Exp $
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

.pixeladdress

	;; Ported from the ZX ROM PIXEL-ADD routine

				; Direct ROM call
				; better not to use it:
;		ld	b,l	; maybe someone wants to
;		ld	c,h	; make a ROM :-)
;		call	8880
;		call	8881
;		xor	@00000111
;		ld	d,h
;		ld	e,l
;		ret


		LD	C,H
		LD	A,L
	        LD      B,A
	        AND     A
	        RRA
	        SCF			; Set Carry Flag
	        RRA
	        AND     A
	        RRA
	        XOR     B
	        AND     @11111000
	        XOR     B
	        LD      D,A
	        LD      A,C
	        RLCA
	        RLCA
	        RLCA
	        XOR     B
	        AND     @11000111
	        XOR     B
	        RLCA
	        RLCA
	        LD      E,A
	        LD      A,C
	        AND     @00000111
	        XOR	@00000111
	        
	        RET
