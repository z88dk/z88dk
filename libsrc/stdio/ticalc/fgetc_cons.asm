;
;	TI calc Routines
;
;	fgetc_cons() Wait for keypress
;
;	Stefano Bodrato - Dec 2000
;
;
;	$Id: fgetc_cons.asm,v 1.5 2001-11-05 09:47:11 stefano Exp $
;

		XLIB	fgetc_cons
		LIB	getk_decode
		XREF	TIei
		XREF	TIdi

		INCLUDE	"stdio/ansi/ticalc/ticalc.inc"

.fgetc_cons
		call	TIei

.kloop
		halt	; Power saving (?? maybe. Surely true on ti86)
IF FORti83p
		rst	$28
		defw	getkey
ELSE
	IF FORti82
		ld	hl,($800C)
		push	hl
	ENDIF
		call	getkey
	IF FORti82
		pop	hl
		ld	($800C),hl
	ENDIF
ENDIF
		and	a
		jr	z,kloop

		call	TIdi
		jp	getk_decode
