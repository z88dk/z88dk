
	SECTION	code_video_vdp

	PUBLIC	l_tms9918_disable_interrupts
	PUBLIC	l_tms9918_enable_interrupts	
	PUBLIC	l_tms9918_enable_interrupts_jp

	EXTERN	l_push_di
	EXTERN	l_pop_ei
	EXTERN	l_pop_ei_jp

	defc	l_tms9918_disable_interrupts = l_push_di
	defc	l_tms9918_enable_interrupts = l_pop_ei
	defc	l_tms9918_enable_interrupts_jp = l_pop_ei_jp

