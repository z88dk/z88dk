;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	set HL = location of 6 byte command string
;	returns command response in A (ZF set if $00)
;
;	$Id: sd_send_command_string.asm,v 1.8 2015-01-19 01:33:07 pauloscustodio Exp $
;


	PUBLIC	sd_send_command_string
	PUBLIC	sd_send_command_null_args
	PUBLIC	sd_send_command_int_args
	PUBLIC	sd_send_command_current_args
	
	PUBLIC	cmd_generic
	PUBLIC	cmd_generic_args
	PUBLIC	cmd_generic_crc

	EXTERN		sd_select_card
	EXTERN		sd_send_eight_clocks
	EXTERN		sd_send_byte
	EXTERN		sd_get_byte



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
	
	call sd_send_eight_clocks		; send 8 clocks first - seems to be necessary for SD cards..
	
	push bc

	ld c,0				; init crc checksum
	ld b,5				; 5 bytes in the actual command string data
sd_sclp:
	ld a,(hl)
	
; --- CRC7 ------------------------------------------------------------------------------------

	ld d,8				; Update CRC for command string with this byte
sd_crclp:
	sla c				; crc <<= 1;
	ld e,a
	xor c
	and $80				; if ((byte & 0x80) ^ (crc & 0x80)) ..
	jr z,sd_isz
	ld a,9				; .. then crc ^= 0x09
	xor c
	ld c,a
sd_isz:
	ld a,e
	rla				; byte <<=1;
	dec d
	jr nz,sd_crclp

; --------------------------------------------------------------------------------------------

	ld a,(hl)	
	call sd_send_byte			; send this command byte to SD card
	inc hl
	djnz sd_sclp

	sla c				; crc = (crc << 1) | 1;
	ld a,1
	or c
	call sd_send_byte			; send CRC command tail
	
	call sd_send_eight_clocks		; skip first byte of nCR. A quirk of the OSCA V6 SD card interface?

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
