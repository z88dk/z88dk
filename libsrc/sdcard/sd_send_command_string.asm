;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	set HL = location of 6 byte command string
;	returns command response in A (ZF set if $00)
;
;	$Id: sd_send_command_string.asm,v 1.6 2012-09-21 14:02:22 stefano Exp $
;


	XLIB	sd_send_command_string
	XDEF	sd_send_command_null_args
	XDEF	sd_send_command_int_args
	XDEF	sd_send_command_current_args
	
	XDEF	cmd_generic
	XDEF	cmd_generic_args
	XDEF	cmd_generic_crc

	XREF	sd_before_get
	
	LIB		sd_select_card
	LIB		sd_send_eight_clocks
	LIB		sd_send_byte
	LIB		sd_get_byte



cmd_generic:        defb $00
; byte order:HLDE
cmd_generic_args:   defb $00,$00,$00,$00
;cmd_generic_crc:    defb $01


sd_send_command_null_args:

	ld de,0

sd_send_command_int_args:

	ld hl,0

sd_send_command:

	ld (cmd_generic_args),hl
	ld (cmd_generic_args+2),de

	
sd_send_command_current_args:

	ld hl,cmd_generic
	ld (hl),a



sd_send_command_string:

; set HL = location of 5 byte command string, checksum is computed
; returns command response in A (ZF set if $00)


	call sd_select_card			; send command always enables card select
	
	call sd_send_eight_clocks		; send 8 clocks first - seems necessary for SD cards..
	
	push bc
	ld c,0	; init crc checksum

	ld b,5
sd_sclp:
	ld a,(hl)
	push hl
	call sd_send_byte			; command byte
	pop hl
	inc hl
	djnz sd_sclp

	sla c				; crc = (crc << 1) | 1;
	ld a,1
	or c

	call sd_send_byte			; crc command tail
	
	;call sd_get_byte			; skip first byte of nCR, a quirk of the OSCA V6 SD card interface?
	call sd_before_get		; this is a slightly lighter workaround, no command byte is sent
							; in this way we should be emulator-safe  ;)

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
