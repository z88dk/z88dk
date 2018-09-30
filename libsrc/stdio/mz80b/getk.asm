;
;	Sharp MZ Routines
;
;	getk() Read key status
;
;	Stefano Bodrato - 5/5/2000
;
;	UncleBod - 2018-09-25
;
;	TODO
;	Conversion of mzASCII to real ASCII, especially codes 0-127

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
IF STANDARDESCAPECHARS
		ld	a,10
ELSE
		ld	a,13
ENDIF
.noenter
 		ld	l,a
		ld	h,0
		ret
