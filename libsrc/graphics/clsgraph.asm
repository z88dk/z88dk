	INCLUDE	"graphics/grafix.inc"

	XLIB	cleargraphics

	XREF	base_graphics

;
;	$Id: clsgraph.asm,v 1.3 2001-04-18 13:21:37 stefano Exp $
;

; ******************************************************************
;
;	Clear graphics	area, i.e. reset all bits in graphics
;	window (256x64	pixels)
;
;	Design & programming by Gunther Strube,	Copyright	(C) InterLogic	1995
;
;	Registers	changed after return:
;		a.bcdehl/ixiy	same
;		.f....../....	different
;
.cleargraphics		push	bc
				push	de
				push	hl
				ld	hl,(base_graphics)	; base of	graphics area
				ld	(hl),0
				ld	d,h
				ld	e,1			; de	= base_graphics+1
				ld	bc,maxx*maxy/8-1
				ldir				; reset graphics window (2K)
				pop	hl
				pop	de
				pop	bc
				ret
