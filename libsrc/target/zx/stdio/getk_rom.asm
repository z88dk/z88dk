;
;	Devilishly simple Spectrum Routines
;
;	getk() Read key status
;
;
;
;	$Id: getk_rom.asm  $
;

		SECTION code_clib
		PUBLIC	getk
		PUBLIC	_getk
		
		    EXTERN in_Inkey


.getk
._getk
	call  in_Inkey
	ld	a,l
IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	l,10
.not_return
ENDIF
	ret
