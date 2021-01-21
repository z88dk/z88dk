
	SECTION code_clib

	PUBLIC	add_raster_int
	PUBLIC	_add_raster_int
	EXTERN	im1_install_isr

        defc            add_raster_int = im1_install_isr
        defc            _add_raster_int = im1_install_isr


	SECTION bss_crt

fw_interrupt:	defw	0

	SECTION	code_crt_init

	EXTERN	im1_install_isr
	EXTERN	asm_im1_handler
	
	di
	ld	hl,($f302)	;System handler
	ld	(fw_interrupt),hl
	push	hl
	call	im1_install_isr
	pop	bc
	ld	hl,asm_im1_handler
	ld	($f302),hl
	ei

	SECTION code_crt_exit
	di
	ld	hl,(fw_interrupt)
	ld	($f302),hl
	ei

