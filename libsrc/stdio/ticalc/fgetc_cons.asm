;
;	TI calc Routines
;
;	fgetc_cons() Wait for keypress
;
;	Stefano Bodrato - Dec 2000
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
		call	getkey
ENDIF
		and	a
		jr	z,kloop

		call	TIdi
		jp	getk_decode

