		SECTION		code_clib

		PUBLIC		asm_im1_handler

		EXTERN		im1_vectors
		EXTERN		asm_interrupt_handler
		

asm_im1_handler:
	push	hl
	push	af
	ld	hl,im1_vectors
	call	asm_interrupt_handler
	pop	af
	ld	hl,(__mc1000_default_irq)
	ex	(sp),hl
	ret


		SECTION		code_crt_init

	di
	ld	hl,($39)
	ld	(__mc1000_default_irq),hl
	ld	hl,asm_im1_handler
	ld	($39),hl
	ei

		SECTION		code_crt_exit

	di
	ld	hl,(__mc1000_default_irq)
	ld	($39),hl
	ei

		SECTION		bss_clib

__mc1000_default_irq:
	defw	0
