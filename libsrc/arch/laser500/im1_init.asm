		SECTION		code_clib
		PUBLIC		im1_init
		PUBLIC		_im1_init

		EXTERN		asm_im1_handler
		EXTERN		l_push_di
		EXTERN		l_pop_ei


im1_init:
_im1_init:
		call	l_push_di
		ld	hl,asm_im1_handler
		ld	($8013),hl
		ld	a,195
		ld	($8012),a
		call	l_pop_ei
		ret

