	INCLUDE	"grafix.inc"
	XLIB	Line

	LIB	Line_r

	XREF	COORDS


; ******************************************************************************
;
;	Draw	a pixel line from (x0,y0) defined (H,L)	- the starting	point coordinate,
;	to the end point (x1,y1).
;
;	Design & programming by Gunther Strube,	Copyright	(C) InterLogic	1995
;
;	The routine checks the range of specified coordinates which	is the boundaries
;	of the graphics area (256x64 pixels).
;	If a	boundary error	occurs the routine exits	automatically.	This	may be
;	useful if	you are trying	to draw a	line	longer than allowed	or outside the
;	graphics borders. Only the visible	part	will	be drawn.
;
;	The coordinate	system is	defined by the	plot	routines which	defines the
;	standard origin (0,0) at	the bottom left corner and (255,63) as the top
;	right corner.
;	However, the hardware graphics memory is organized as (0,0)	in the top
;	left	corner and (255,63)	as the bottom right	corner. The plot routines
;	adjusts for this automatically.
;
;	The plot routine is	defined by an address pointer	in IX.
;	This	routine converts the absolute	coordinates to	a relative distance	as (dx,dy)
;	defining (COORDS) with (x0,y0) and	a distance in (dx,dy). The drawing	is then
;	executed by Line_r .
;
;	IN:	HL =	(x0,y0) -	x0 range is 0 to 255, y0	range is 0 to 63.
;		DE =	(x1,y1) -	x1 range is 0 to 255, y1	range is 0 to 63.
;		IX =	pointer to plot routine that uses HL = (x,y)	of plot coordinate.
;
;	OUT:	None.
;
;	Registers	changed after return:
;		..BCDEHL/IXIY/af......	same
;		AF....../..../..bcdehl	different
;
.Line			push	de
				push	hl
				ld	a,l
				cp	maxy
				jr	nc, exit_line		; y0	coordinate out	of range
				ld	a,e
				cp	maxy
				jr	nc, exit_line		; y1	coordinate out	of range
				ld	(COORDS),hl		; the starting	point is now default
				push	hl
				push	de
				ld	l,h				; L = x0
				ld	h,d				; H = x1
				call	distance			; x1	- x0	horisontal distance	in HL
				pop	de
				ex	(sp),hl			; L = y0
				ld	h,e				; H = y1
				call	distance			; y1	- y0	vertical distance in HL
				pop	de
				ex	de,hl			; h.dist.	= HL, v.dist. = DE
				call	Line_r			; draw line...

.exit_line		pop	hl
				pop	de
				ret



; ***************************************************************************
;
; calculate distance
; IN:	H = destination point
;		L = source point
;
; OUT: h - l distance in	HL
;
.distance			ld	a,h
				sub	l
				ld	l,a
				ld	h,0
				ret	nc
				ld	h,-1
				ret
