;
;	TI calc Routines
;
;	fgetc_cons() Wait for keypress
;
;	Stefano Bodrato - Dec 2000
;

		XLIB	fgetc_cons
		LIB	getk_decode

		INCLUDE	"stdio/ansi/ticalc/ticalc.inc"

.fgetc_cons

.kloop
		halt	; Power saving (?? maybe. Surely true on ti86)
		call	getkey
		and	a
		jr	z,kloop

		jp	getk_decode

