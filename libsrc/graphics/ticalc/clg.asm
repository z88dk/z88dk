;
;       Z88 Graphics Functions - Small C+ stubs
;
;       TI Calc version by Stefano Bodrato  Mar - 2000
;
;
;	$Id: clg.asm,v 1.3 2011-08-12 16:57:41 pauloscustodio Exp $
;


	INCLUDE "graphics/grafix.inc"    ; Contains fn defs

	XLIB    clg
	XREF	base_graphics
	XREF	cpygraph

.clg
  	ld	hl,(base_graphics)
	ld	(hl),0
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,row_bytes*64-1
	ldir

	jp	cpygraph	; Copy GRAPH_MEM to LCD, then return
