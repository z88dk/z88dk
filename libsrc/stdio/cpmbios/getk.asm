;
;	Keyboard routines for the CP/M BIOS
;	Created for Robotron KC81/1, KC/87, Z9001  but kept generic
;
;	By Stefano Bodrato - Sept. 2016
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.1 2016-09-22 06:29:49 stefano Exp $
;

		SECTION code_clib
		PUBLIC	getk
		PUBLIC	_getk

.getk
._getk

    call $f006          ; const: Check if a key is waiting (0=key, 0ffh=no key)
    inc a
	jr z,gkret
    call z,$f009        ; conin: Get a key if one is waiting

.gkret
	ld	l,a
	ld	h,0
	ret
