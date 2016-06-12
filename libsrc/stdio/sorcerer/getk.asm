;
;	Keyboard routines for the Sorcerer Exidy
;	By Stefano Bodrato - 23/05/2011 (exactly 8 years after the Nascom ones !)
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.3 2016-06-12 17:32:01 dom Exp $
;


        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
	call $e009
	ld	l,a
	ld	h,0
	ret
