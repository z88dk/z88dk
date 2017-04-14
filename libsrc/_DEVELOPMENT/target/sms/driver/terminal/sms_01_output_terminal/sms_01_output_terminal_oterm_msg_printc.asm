SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC sms_01_output_terminal_oterm_msg_printc

EXTERN __IO_VDP_DATA
EXTERN asm_sms_set_vram_write_de

sms_01_output_terminal_oterm_msg_printc:

	;	 enter  :  c = ascii code
	;				  l = absolute x coordinate
	;				  h = absolute y coordinate
	;	 can use:  af, bc, de, hl

	; accept all ascii codes including unprintable ones
	
	ex de,hl
	
	; d = y
	; e = x
	
	ld l,d
	ld h,0
	ld d,h
	
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	
	add hl,de
	add hl,hl						 ; hl = 64*y + 2*x
	
	ld e,(ix+21)
	ld d,(ix+22)					 ; de = screen map base address
	
	add hl,de
	ex de,hl							 ; de = address of character in screen map
	
	call asm_sms_set_vram_write_de
	
	ld a,c							 ; ascii code
	add a,(ix+23)					 ; add character offset low byte
	out (__IO_VDP_DATA),a

   sbc a,a
	adc a,(ix+24)					 ; add character offset high byte
	and $01
	or (ix+25)						 ; or in character attribute flags
	out (__IO_VDP_DATA),a

	ret
