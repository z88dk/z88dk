
	XLIB	cleargraphics

	XREF	base_graphics

;
;	$Id: clsgraph.asm,v 1.3 2001-04-18 13:21:38 stefano Exp $
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
			call	2602	
			pop	hl
			pop	de
			pop	bc
			ret
