;
;	Sharp MZ Routines
;
;	getk() Read key status
;
;	Stefano Bodrato - 5/5/2000
;
;
;	$Id: getk.asm,v 1.3 2015-01-19 01:33:20 pauloscustodio Exp $
;


		PUBLIC	getk

.getk
		call	$1B   ;get key
		cp	$66   ;was it ENTER ?
		jr	nz,noenter
		ld	a,13
.noenter
 		ld	l,a
		ld	h,0
		ret
