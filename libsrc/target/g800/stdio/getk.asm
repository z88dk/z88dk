;
;	Sharp PC G-800 family stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 2017
;
;
;	$Id: getk.asm - stefano Exp $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

	EXTERN key_to_asc
	
.getk
._getk
	call $be53
	jp key_to_asc
