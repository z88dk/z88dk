;
; 	ANSI Video handling for the TI calculators
;	By Stefano Bodrato - Dec. 2000
;
; 	Clean a text line
;
; in:	A = text row number
;

	INCLUDE	"stdio/ansi/ticalc/ticalc.inc"

	XLIB	ansi_del_line
	XREF	base_graphics
	XREF	cpygraph


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
