;
;	Enterprise 64/128 C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - 2011
;
;
;	$Id: getk.asm,v 1.1 2011-02-17 20:44:23 stefano Exp $
;

	XLIB	getk
	LIB	fgetc_cons


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

