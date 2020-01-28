;
;	Enterprise 64/128 C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - 2011
;
;
;	$Id: getk.asm,v 1.4 2016-06-12 17:07:44 dom Exp $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk
	EXTERN	fgetc_cons


.getk
._getk

	ld   a,69h ; keyboard channel
	rst  $30   ; EXOS
	defb 9     ; test channel

	; C = 0: peripheral ready
	; C = 1: not ready
	; C = FFH: end of file
	ld	a,c
	and	a
	jp	z,fgetc_cons

	ld	hl,0
	ret

