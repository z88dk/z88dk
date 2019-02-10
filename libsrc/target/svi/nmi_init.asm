		SECTION		code_clib
		PUBLIC		nmi_init
		PUBLIC		_nmi_init

		EXTERN		asm_nmi_handler
		EXTERN		l_push_di
		EXTERN		l_pop_ei


nmi_init:
_nmi_init:
		ld	hl,asm_nmi_handler
		ld	($ff7f),hl
		ld	a,195
		ld	($ff7e),a
		ret

