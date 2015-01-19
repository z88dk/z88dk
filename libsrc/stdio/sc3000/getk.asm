;
;   SEGA SC-3000 C Library
;
;	getk() Read key status
;
;	$Id: getk.asm,v 1.2 2015-01-19 01:33:21 pauloscustodio Exp $
;

		PUBLIC	getk

.getk
	call	$42D4
	ld	l,a
	ld	h,0
	ret
