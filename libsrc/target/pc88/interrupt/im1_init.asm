
	SECTION code_clib

	PUBLIC	im1_init
	PUBLIC	_im1_init
	EXTERN	im1_install_isr
	EXTERN	asm_im1_handler

im1_init:
_im1_init:
	di
	ld	hl,($f302)	;System handler
	ld	(fw_interrupt),hl
	push	hl
	call	im1_install_isr
	pop	bc
	ld	hl,asm_im1_handler
	ld	($f302),hl
	ei
	ret



	SECTION bss_crt

fw_interrupt:	defw	0

	
	SECTION code_crt_exit
	di
	ld	hl,(fw_interrupt)
	ld	($f302),hl
	ei

