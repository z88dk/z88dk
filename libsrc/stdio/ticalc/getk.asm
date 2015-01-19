;
;	TI calc Routines
;
;	getk() Read key status
;
;	Stefano Bodrato - Dec 2000
;
;
;	$Id: getk.asm,v 1.7 2015-01-19 01:33:21 pauloscustodio Exp $
;

		PUBLIC	getk
		EXTERN	getk_decode
		EXTERN	tidi
		EXTERN	tiei

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
