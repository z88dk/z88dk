;
;   CLS for the Amstrad NC
;   Stefano - 2017
;
;
;	$Id: clg.asm $
;

	SECTION	code_clib
        PUBLIC    clg
        PUBLIC    _clg

        EXTERN     swapgfxbk
        EXTERN    swapgfxbk1
.clg
._clg
		call swapgfxbk
		xor a
IF FORnc100
		ld  hl,$4000+$3000
ELSE
		ld  hl,$4000+$2000
ENDIF
		ld (hl),a
		ld d,h
		ld e,l
		inc de
IF FORnc100
		ld bc,4095
ELSE
		ld bc,8191
ENDIF
		ldir
		jp swapgfxbk1

