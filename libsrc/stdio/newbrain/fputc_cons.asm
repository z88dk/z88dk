;
; 	Basic video handling for the Grundy Newbrain
;	By Stefano Bodrato May 2005
;
;	(HL)=char to display
;
;
;	$Id: fputc_cons.asm,v 1.2 2007-05-14 12:40:47 stefano Exp $
;

	XLIB	fputc_cons

.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	;cp	13
	;ld	a,28		; cursor home left
	;ld	a,13		; next line + scroll
	
	cp	12
	jr	nz,nocls
	ld	a,31
.nocls
.doprint
	ld	e,0
	rst	20h
	defb	30h
	ret
