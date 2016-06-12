;
;	Sharp MZ Routines
;
;	getk() Read key status
;
;	Stefano Bodrato - 5/5/2000
;
;
;	$Id: getk.asm,v 1.4 2016-06-12 17:32:01 dom Exp $
;


        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
		call	$1B   ;get key
		cp	$66   ;was it ENTER ?
		jr	nz,noenter
		ld	a,13
.noenter
 		ld	l,a
		ld	h,0
		ret
