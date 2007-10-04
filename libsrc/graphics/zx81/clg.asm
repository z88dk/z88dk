
	XLIB	cleargraphics

	XREF	base_graphics

;
;	$Id: clg.asm,v 1.1 2007-10-04 10:28:47 stefano Exp $
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
.clg
			jp	2602	
