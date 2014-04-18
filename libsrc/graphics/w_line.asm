	INCLUDE	"graphics/grafix.inc"
	
	XLIB	w_line

	LIB	w_line_r

	XREF	coords

;
;	$Id: w_line.asm,v 1.4 2014-04-18 09:30:31 stefano Exp $
;

; ******************************************************************************
;
;	Draw a pixel line from (x0,y0) defined in COORDS (word,word) - the starting point coordinate,
;	to the end point (HL,DE).
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;

.w_line
		ex	de,hl
		ld	bc,(coords+2)
		or	a
		sbc	hl,bc
		ex	de,hl

		ld	bc,(coords)
		or	a
		sbc	hl,bc
.nocrossx
		jp	w_line_r
