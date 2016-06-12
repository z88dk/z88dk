;
;	TI calc Routines
;
;	getk() Read key status
;
;	Stefano Bodrato - Dec 2000
;
;
;	$Id: getk.asm,v 1.8 2016-06-12 17:32:01 dom Exp $
;

 	       SECTION code_clib
		PUBLIC	getk
		PUBLIC	_getk
		EXTERN	getk_decode
		EXTERN	tidi
		EXTERN	tiei

		INCLUDE	"stdio/ansi/ticalc/ticalc.inc"

.getk
._getk
		call	tiei
IF FORti83p
		rst	$28
		defw	getkey
ELSE
		call	getkey
ENDIF
		call	tidi
		jp	getk_decode
