

		SECTION		code_clib
		PUBLIC		__graphics_end

		EXTERN		swapgfxbk1


__graphics_end:
		call	swapgfxbk1
		pop	ix
		ret
