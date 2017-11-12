;
;	CCE MC-1000 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato, 2013
;
;
;	$Id: getk.asm $
;


; SKEY?: keyboard reading for games
; A = #00 :   no key pressed
; A = #FF :   key code is in #011B


        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
	call	$C027
	ld		hl,0
	and		a
	ret		z
	ld		a,($011B)

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF
        cp      92
        jr      nz,not_spc
        ld      a,32
.not_spc

	ld	l,a
	ret
