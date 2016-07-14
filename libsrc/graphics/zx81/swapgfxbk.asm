;
;       ZX81 Graphics Functions - Small C+ stubs
;
;	ZX 81 version By Stefano Bodrato
;
;	$Id: swapgfxbk.asm,v 1.10 2016-07-14 17:44:17 pauloscustodio Exp $
;

	        SECTION code_clib
                PUBLIC    swapgfxbk

		PUBLIC	swapgfxbk1
		
		;EXTERN	save81
		;EXTERN	restore81

.swapgfxbk
	        ;jp	$2E7	;setfast
		ret
		;jp	save81
.swapgfxbk1
		; This will become IY when swapped !
		ld	ix,16384 
		;jp	$207
		ret
                ;jp	restore81
