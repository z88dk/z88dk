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

IF FORti83p
		rst	$28
		defw	getkey
ELSE
		call	getkey
ENDIF
		jp	getk_decode
