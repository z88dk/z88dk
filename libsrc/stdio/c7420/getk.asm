;
;	Keyboard routines for the Philips Videopac C7420
;	By Stefano Bodrato - 2015
;
;	getk() Read key status
;
;
;	$Id:
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
	call $a22
	ld h,0
	ld l,a
	ret
