	
	SECTION code_graphics
	PUBLIC	cleargraphics

;	$Id: cleargraphics.asm $


; ******************************************************************
;
;	Clear graphics	area, i.e. reset all bits in graphics window
;
;	Design & programming by Gunther Strube,	Copyright	(C) InterLogic	1995
;
;	Registers	changed after return:
;		a.bcdehl/ixiy	same
;		.f....../....	different
;
.cleargraphics
	ld	hl,$f800
	ld	de,$f801
	ld	bc,+(80 * 25) - 1
	ld	(hl),' '
	ldir
	ret
