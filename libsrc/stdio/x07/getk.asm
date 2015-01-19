;
;	Keyboard routines for the Canon X-07
;	By Stefano Bodrato - 10/6/2011
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.2 2015-01-19 01:33:22 pauloscustodio Exp $
;

		PUBLIC	getk

.getk
	xor	a
	jp $C90A
