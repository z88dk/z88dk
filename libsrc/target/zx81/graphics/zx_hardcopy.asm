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
		jp	$1CC3
ELSE
		jp	$0869
ENDIF
