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
IF FORzcn
	ld	e,1	; ^A
	ld	c,2
	jp	5
ELSE
		jp $B824
ENDIF


