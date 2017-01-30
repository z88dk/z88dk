;
;	Keyboard routines
;	Created for Robotron KC85 but kept generic
;	By Stefano Bodrato - Sept. 2016
;
;	getkey() Wait for keypress
;
;
;	$Id: fgetc_cons.asm,v 1.1 2016-09-22 06:29:49 stefano Exp $
;


		SECTION	code_clib
		PUBLIC	fgetc_cons
		PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons

;    call $f006          ; const: Check if a key is waiting (0=key, 0ffh=no key)
;    inc a
;	jr nz,fgetc_cons
    call z,$f009        ; conin: Get a key if one is waiting

	ld	l,a
	ld	h,0
	ret
