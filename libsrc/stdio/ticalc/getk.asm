;
;	TI calc Routines
;
;	getk() Read key status
;
;	Stefano Bodrato - Dec 2000
;

		XLIB	getk
		LIB	getk_decode
		XREF	TIdi
		XREF	TIei

		INCLUDE	"stdio/ansi/ticalc/ticalc.inc"

.getk
		call	TIei
IF FORti83p
		rst	$28
		defw	getkey
ELSE
		call	getkey
ENDIF
		call	TIdi
		jp	getk_decode
