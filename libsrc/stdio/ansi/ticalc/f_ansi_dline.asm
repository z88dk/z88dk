;
; 	ANSI Video handling for the TI calculators
;	By Stefano Bodrato - Dec. 2000
;
; 	Clean a text line
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.6 2016-06-12 16:06:43 dom Exp $
;

	INCLUDE	"stdio/ansi/ticalc/ticalc.inc"

        SECTION code_clib
	PUBLIC	ansi_del_line
	EXTERN	base_graphics
	EXTERN	cpygraph


.ansi_del_line
	ld	de,row_bytes*8
	ld	b,a
	ld	hl,(base_graphics)
	and	a
	jr	z,zline
.lloop
	add	hl,de
	djnz	lloop
.zline	
	ld	d,h
	ld	e,l
	inc	de
	ld	(hl),0
	ld	bc,row_bytes*8
	ldir
	
	jp	cpygraph	; Copy GRAPH_MEM to LCD, then return
