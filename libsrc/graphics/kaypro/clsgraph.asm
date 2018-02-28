	INCLUDE	"graphics/grafix.inc"

                SECTION         code_clib
	PUBLIC	cleargraphics
   PUBLIC   _cleargraphics

;
;	$Id: clsgraph.asm $
;

; ******************************************************************
;
;	Clear graphics	area, i.e. reset all bits in graphics
;
;	Design & programming by Gunther Strube,	Copyright	(C) InterLogic	1995
;
;	Registers	changed after return:
;		a.bcdehl/ixiy	same
;		.f....../....	different
;
.cleargraphics
._cleargraphics
	ld	e,$1a
	ld	c,2
	jp 5
