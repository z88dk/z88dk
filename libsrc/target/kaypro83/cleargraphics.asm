        SECTION code_graphics
	PUBLIC	cleargraphics


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
.cleargraphics
	ld	hl,$3000
	ld	de,$3001
	ld	bc,+(128 * 24) - 1
	ld	(hl),' '
	ldir
	ret
