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
		jp $B824

