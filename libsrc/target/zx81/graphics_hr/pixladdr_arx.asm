;--------------------------------------------------------------
; ARX816 style Graphics
; for the ZX81
;--------------------------------------------------------------

	SECTION code_clib
	PUBLIC	pixeladdress

	EXTERN	base_graphics

;
;	$Id: pixladdr_arx.asm,v 1.3 2016-06-27 20:26:33 dom Exp $
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
	ld	b,h     ; X
	ld	c,l     ; Y

	ld	a,c     ;ycord in A
	srl	a       ;shift it right
	srl	a       ;3	
	srl	a       ;times
	ld	hl,base_graphics+1
	or	(hl)    ;or in base address MSB
	ld	d,a     ;** MSB in D
	ld	a,c     ;get y cord again
	and	7       ;just bits 2,1,0
	ld	c,a
	ld	a,b
	and	7
	ld	h,a     ;save it
	ld	a,b     ;get xcord
	and	$f8     ;all but bits 2,1,0
	or	c       ;or in the line bits
	ld	e,a     ;** LSB in E
	ld	a,h
	or	$f8     ;set all unused bits 1
	cpl         ;they now become 0
	ret
