
	XLIB	pixeladdress
	
	LIB	zx_rowtab

	INCLUDE	"graphics/grafix.inc"

;
;	$Id: pixladdr2.asm,v 1.1 2002-02-27 13:12:26 stefano Exp $
;

; ******************************************************************
;
; Table based version - Stefano 19/2/2002
; Seems to have exactly the same speed of pixladdr.asm
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
;  ..bc..../ixiy same
;  af..dehl/.... different
;


.pixeladdress

		ld	a,h
		ld	d,0
		ld	e,l
		
		ld	hl,zx_rowtab
		add	hl,de
		add	hl,de
		
		ld	e,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,e
		
		ld	e,a
		srl	e
		srl	e
		srl	e

		add	hl,de
		ld	d,h
		ld	e,l

	        AND     @00000111
	        XOR	@00000111
	        
	        RET

