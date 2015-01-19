;
;	Enterprise 64/128 C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - 2011
;
;
;	$Id: getk.asm,v 1.2 2015-01-19 01:33:20 pauloscustodio Exp $
;

	PUBLIC	getk
	EXTERN	fgetc_cons


.getk

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

