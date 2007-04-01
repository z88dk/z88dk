;
; 	Basic video handling for the Grundy Newbrain
;	By Stefano Bodrato May 2005
;
;	(HL)=char to display
;
;
;	$Id: fputc_cons.asm,v 1.1 2007-04-01 20:48:40 stefano Exp $
;

	XLIB	fputc_cons

.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	cp	12
	jr	nz,nocls
	ld	a,31
.nocls
	ld	e,0
	rst	20h
	defb	30h
	ret
