

		SECTION code_clib
		EXTERN swapgfxbk1
		PUBLIC __oz_gfxend

__oz_gfxend:
		call	swapgfxbk1
		pop	ix	;restore callers
		ret
	
