
	xlib	drawbox

	lib	setxy, line_r

; ******************************************************************
;
; Draw box in graphics window. The	box is only drawn inside	the
; boundaries of the	graphics area.
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
;	in:	hl =	(x,y)
;		bc =	width, height
;		ix =	pointer to plot routine
;
;	out:	None.
;
;	registers	changed after return:
;		afbcdehl/ixiy	same
;		......../....	different
;
.drawbox			push	af
				push	de
				push	hl
				call	setxy		; set graphics	coordinate

				ld	h,0
				ld	l,b
				dec	hl			; first plot after (x,y), width-1
				ld	de,0			; drawline(width-1,	0)
				call	line_r
				ld	hl,0
				ld	d,0
				ld	e,c
				cp	a
				sbc	hl,de
				ex	de,hl
				inc	de
				ld	hl,0			; drawline(0, -heigth+1)
				call	line_r
				ld	hl,0
				ld	d,0
				ld	e,b
				cp	a
				sbc	hl,de
				inc	hl			; -width-1
				ld	de,0
				call	line_r		; drawline(-width+1, 0)
				ld	hl,0
				ld	d,0
				ld	e,c
				dec	de
				call	line_r		; drawline(0, height-1)

				pop	hl
				pop	de
				pop	af
				ret
