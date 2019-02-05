
	SECTION	code_clib

	PUBLIC	l_tms9918_disable_interrupts
	PUBLIC	l_tms9918_enable_interrupts	

	EXTERN	l_push_di
	EXTERN	l_pop_ei

	defc	l_tms9918_disable_interrupts = l_push_di
	defc	l_tms9918_enable_interrupts = l_pop_ei

