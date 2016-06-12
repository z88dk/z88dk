;
; 	ANSI Video handling for the TI calculators
;	By Stefano Bodrato - Dec. 2000
;
; 	CLS - Clear the screen
;	
;
;	$Id: f_ansi_cls.asm,v 1.6 2016-06-12 16:06:43 dom Exp $
;

	INCLUDE	"stdio/ansi/ticalc/ticalc.inc"

        SECTION code_clib
	PUBLIC	ansi_cls
	EXTERN	base_graphics
	EXTERN	cpygraph

.ansi_cls
  	ld	hl,(base_graphics)
	ld	(hl),0
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,row_bytes*64
	ldir

	jp	cpygraph	; Copy GRAPH_MEM to LCD, then return
