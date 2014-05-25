;
;	TI calc Routines
;
;	getk() Read key status
;
;	Stefano Bodrato - Dec 2000
;
;
;	$Id: getk.asm,v 1.6 2014-05-25 19:48:04 stefano Exp $
;

		XLIB	getk
		LIB	getk_decode
		XREF	tidi
		XREF	tiei

		INCLUDE	"stdio/ansi/ticalc/ticalc.inc"

.getk
		call	tiei
IF FORti83p
		rst	$28
		defw	getkey
ELSE
		call	getkey
ENDIF
		call	tidi
		jp	getk_decode
