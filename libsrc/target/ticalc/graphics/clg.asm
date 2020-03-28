;
;       Z88 Graphics Functions - Small C+ stubs
;
;       TI Calc version by Stefano Bodrato  Mar - 2000
;
;
;	$Id: clg.asm,v 1.5 2017-01-02 22:57:59 aralbrec Exp $
;


	INCLUDE "graphics/grafix.inc"    ; Contains fn defs

	PUBLIC    clg
   PUBLIC    _clg
	EXTERN	base_graphics
	EXTERN	cpygraph

.clg
._clg
  	ld	hl,(base_graphics)
	ld	(hl),0
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,row_bytes*64-1
	ldir

	jp	cpygraph	; Copy GRAPH_MEM to LCD, then return
