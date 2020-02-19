;
;       TRS 80 Model 100 C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - Feb 2020
;
;
;	$Id: getk.asm $
;


        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
        call    $13DB
		ld	a,0
		JP Z,INKEY_S_0
		
        call    $12CB

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

.INKEY_S_0
        ld      l,a
	ld	h,0
	ret
