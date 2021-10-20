		SECTION		code_clib
		PUBLIC		im1_init
		PUBLIC		_im1_init

		EXTERN		l_push_di
		EXTERN		l_pop_ei
                EXTERN          im1_vectors
		EXTERN          asm_interrupt_handler
		EXTERN		asm_im1_install_isr
		EXTERN		__tms9918_status_register


im1_init:
_im1_init:
	call	l_push_di
	ld	hl,$fd9f
	ld	de,existing_int
	ld	bc,5
	ldir
	ld	hl,asm_im1_handler
	ld	($fd9f+1),hl
	ld	a,195
	ld	($fd9f),a
	; Add the code that was originally there as the first interrupt
	ld	de,existing_int
	call	asm_im1_install_isr
	call	l_pop_ei
	ret

; On the MSX hooking into fd9f we just need to save af
asm_im1_handler:
	push	af
	; We enter with a holding the VDP status register,
	; the previous value is held in $f3e7
	ld	(__tms9918_status_register),a
        ld      hl,im1_vectors
	call    asm_interrupt_handler
	pop	af
	ret
	

	SECTION	bss_driver

existing_int:	
	defs	5
