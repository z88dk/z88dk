
	XLIB	cleargraphics

	XREF	base_graphics

;
;	$Id: clsgraph.asm,v 1.4 2008-03-31 17:16:20 stefano Exp $
;

; ******************************************************************
;
;	Clear graphics	area, i.e. reset all bits and sets graphics mode
;
;	Design & programming by Gunther Strube,	Copyright (C) InterLogic 1995
;	ported by Stefano Bodrato
;
;	Registers	changed after return:
;		a.bcdehl/ixiy	same
;		.f....../....	different
;
.cleargraphics
				push	bc
				push	de
				push	hl

				ld	a,8
				ld	(6800h),a
				ld	(783bh),a		; force graph mode

				ld	hl,(base_graphics)	; base of graphics area
				ld	(hl),0
				ld	d,h
				ld	e,1			; de	= base_graphics+1
				ld	bc,128*64/4-1
				ldir				; reset graphics window (2K)
				pop	hl
				pop	de
				pop	bc
				ret
