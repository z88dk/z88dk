;
;	Keyboard routines for the Canon X-07
;	By Stefano Bodrato - 10/6/2011
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.3 2016-06-12 17:32:01 dom Exp $
;

	SECTION	code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
	xor	a
	jp $C90A
