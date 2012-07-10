;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	set HL = location of 6 byte command string
;	returns command response in A (ZF set if $00)
;
;	$Id: sd_send_command_string.asm,v 1.1 2012-07-10 05:55:38 stefano Exp $
;


	XLIB	sd_send_command_string
	XDEF	sd_send_command_null_args
	XDEF	sd_send_command_current_args
	
	XDEF	cmd_generic
	XDEF	cmd_generic_args
	XDEF	cmd_generic_crc
	
	LIB		sd_select_card
	LIB		sd_send_eight_clocks
	LIB		sd_send_byte
	LIB		sd_wait_valid_response
	LIB		sd_get_byte



cmd_generic:        defb $00
cmd_generic_args:   defb $00,$00,$00,$00
cmd_generic_crc:    defb $01


sd_send_command_null_args:

	ld hl,0
	ld (cmd_generic_args),hl
	ld (cmd_generic_args+2),hl
	

	
sd_send_command_current_args:
	
	ld hl,cmd_generic
	ld (hl),a



sd_send_command_string:

	call sd_select_card			; send command always enables card select
	
	call sd_send_eight_clocks		; send 8 clocks first - seems necessary for SD cards..
	
	push bc
	ld b,6
sd_sclp:
	ld a,(hl)
	call sd_send_byte			; command byte
	inc hl
	djnz sd_sclp
	pop bc
	
	call sd_get_byte			; skip first byte of nCR, a quirk of my SD card interface?
		

sd_wait_valid_response:
	
	push bc
	ld b,0
sd_wncrl:
	call sd_get_byte			; read until Command Response from card 
	bit 7,a				; If bit 7 = 0, it's a valid response
	jr z,sd_gcr
	djnz sd_wncrl
					
sd_gcr:
	or a				; zero flag set if Command response = 00
	pop bc
	ret
