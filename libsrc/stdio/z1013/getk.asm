;
;	Keyboard routines for the Robotron Z1013
;	By Stefano Bodrato - Aug. 2016
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.1 2016-08-05 07:04:10 stefano Exp $
;

		SECTION code_clib
		PUBLIC	getk
		PUBLIC	_getk

.getk
._getk

	rst $20
	defb 1		; 'INCH' function

.gkret
	ld	l,a
	ld	h,0
	ret
