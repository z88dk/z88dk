		SECTION		code_clib
		PUBLIC		im1_init
		PUBLIC		_im1_init

		EXTERN		l_push_di
		EXTERN		l_pop_ei
                EXTERN          im1_vectors
		EXTERN          asm_interrupt_handler


im1_init:
_im1_init:
	call	l_push_di
	ld	hl,asm_im1_handler
	ld	($fd9b),hl
	ld	a,195
	ld	($fd9a),a
	call	l_pop_ei
	ret

; On the MSX all registers are preserved for us by the firmware, so no need to 
; do it here. We also shouldn't return with a reti since the interrupt
; routine carries on
asm_im1_handler:
        ld      hl,im1_vectors
	call    asm_interrupt_handler
	ret
	
