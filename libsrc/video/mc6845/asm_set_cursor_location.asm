
  		SECTION		code_clib

  		PUBLIC		asm_set_cursor_location

  		INCLUDE		"mc6845.inc"

  ; Set the location of the hardware cursor
 ;
 ; Entry: hl = offset in RAM
 ; Uses:  a
 asm_set_cursor_location:
 	ld	a,0x0e
 	out	(address_w),a
 	ld	a,h	
 	out	(register_w),a
 	ld	a,0x0f
 	out	(address_w),a
 	ld	a,l	
 	out	(register_w),a
 	ret
