;
;       Sharp X1 Stdio
;
;       getk() - Read key status
;
;       Karl Von Dyson (for X1s.org) - 24/10/2013
;

        SECTION code_clib
        PUBLIC getk
        PUBLIC _getk
		
		EXTERN _x1_keyboard_io

getk:
_getk:

        ld hl, _x1_keyboard_io
        ld a, (hl)

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

        ld h,0
        ld l,a
		ret
