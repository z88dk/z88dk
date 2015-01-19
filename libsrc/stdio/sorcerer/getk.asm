;
;	Keyboard routines for the Sorcerer Exidy
;	By Stefano Bodrato - 23/05/2011 (exactly 8 years after the Nascom ones !)
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.2 2015-01-19 01:33:21 pauloscustodio Exp $
;

		PUBLIC	getk

.getk
	call $e009
	ld	l,a
	ld	h,0
	ret
