;
;	TI calc Routines
;
;	getk() Read key status
;
;	Stefano Bodrato - Dec 2000
;

		XLIB	getk
		LIB	getk_decode

		INCLUDE	"stdio/ansi/ticalc/ticalc.inc"

.getk
		call	getkey

		jp	getk_decode
