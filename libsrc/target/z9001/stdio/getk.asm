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

    call $f006          ; const: Check if a key is waiting (0 = no key, 0ffh = key ready)
    and a
	jr z,gkret
    call $f009        ; conin: Get a key if one is waiting

.gkret

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	l,a
	ld	h,0
	ret
