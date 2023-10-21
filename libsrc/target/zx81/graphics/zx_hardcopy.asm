;
;		Copy the graphics area to the zx printer
;
;		Stefano Bodrato, 2018
;
;
;	$Id: zx_hardcopy.asm $
;
		SECTION code_clib
		PUBLIC    zx_hardcopy
		PUBLIC    _zx_hardcopy
		
		EXTERN  restore81


.zx_hardcopy
._zx_hardcopy

	call	restore81

IF FORlambda

	ld a,(7)
	cp $25
	jp	z,$1CC3 ; Color ROM

	cp $1d
	jp z,$A0A  ; Old Monochrome ROM

	jp $1E47   ; CAC-3 or NF300

ELSE

	jp	$0869

ENDIF
