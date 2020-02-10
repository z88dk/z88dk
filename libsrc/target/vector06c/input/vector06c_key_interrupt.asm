

	SECTION	code_driver

	PUBLIC	__vector06c_key_interrupt

	PUBLIC	__vector06c_key_rows
	EXTERN	__vector06c_scroll

__vector06c_key_interrupt:
	; af,bc,dehl preserved by im1 handler
	ld	a,$8a
	out	(0),a
	ld	hl,__vector06c_key_rows
	ld	b,@11111110
key_loop:
	ld	a,b
	out	(3),a
	in	a,(2)
	cpl
	ld	(hl),a
	inc	hl
	ld	a,b
	rlca
	ld	b,a
	jr	c,key_loop
	in	a,(1)	;Keyboard line 8
	cpl
	ld	(hl),a
	ld	a,$88
	out	(0),a
	ld	a,(__vector06c_scroll)
	out	(3),a
	ret


	SECTION	bss_driver

	; Key rows populated by the interrupt - used by inkey and friends
__vector06c_key_rows:
	defs	9



	SECTION	code_crt_init
	EXTERN	im1_install_isr

	ld	hl,__vector06c_key_interrupt
	push	hl
	call	im1_install_isr
	pop	bc
	
