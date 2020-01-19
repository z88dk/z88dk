

		SECTION		code_graphics
		PUBLIC		__graphics_end

		EXTERN		swapgfxbk1


__graphics_end:
		call	swapgfxbk1
IF !__CPU_INTEL__ & !__CPU_GBZ80__
		pop	ix
ENDIF
		ret
