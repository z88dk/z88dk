;
;       ZX81 Graphics Functions - Small C+ stubs
;
;	ZX 81 version By Stefano Bodrato
;
;	$Id: swapgfxbk.asm,v 1.8 2015-01-19 01:32:52 pauloscustodio Exp $
;


                PUBLIC    swapgfxbk

		PUBLIC	swapgfxbk1
		
		;XREF	save81
		;XREF	restore81

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
