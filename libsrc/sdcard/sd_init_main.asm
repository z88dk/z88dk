;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;
;	Ported by Stefano Bodrato, 2012
;
;	Init SD card communications
;	On entry: A=card slot number
;
;	$Id: sd_init_main.asm,v 1.6 2015-01-19 01:33:07 pauloscustodio Exp $
;


	PUBLIC	sd_init_main
	
	EXTERN		pause_4ms
	EXTERN		sd_power_on
	EXTERN		sd_power_off
	EXTERN		sd_send_eight_clocks
	EXTERN		sd_send_command_string
	EXTERN	sd_send_command_int_args
	EXTERN	sd_send_command_null_args
	EXTERN	sd_card_info
	EXTERN		sd_read_bytes_to_sector_buffer
	

    INCLUDE "sdcard.def"
    
    EXTERN	sd_card_info


;CMD0_string:
;	defb $40,$00,$00,$00,$00,$95
;	defb $40,$00,$00,$00,$00


IF SDHC_SUPPORT

;CMD8_string:
;	defb $48,$00,$00,$01,$aa,$87
;	defb $48,$00,$00,$01,$aa

ACMD41HCS_string:
;	defb $69,$40,$00,$00,$00,$01
	defb $69,$40,$00,$00,$00

ENDIF


sd_init_main:

	and a				; Requested SD card slot <> 0 ?
	ret nz				; then return with A carrying an error status
	
	ld (sd_card_info),a		; reset card info flags

	call sd_power_off			; Switch off power to the card (SPI clock slow, /CS is low but should be irrelevent)
	
	ld b,128				; wait approx 0.5 seconds
sd_powod:
	call pause_4ms
	djnz sd_powod			
		
	call sd_power_on			; Switch card power back on (SPI clock slow, /CS high - de-selected)
		
	ld b,10				; send 80 clocks to ensure card has stabilized
sd_ecilp:
	call sd_send_eight_clocks
	djnz sd_ecilp
	
	ld	a,CMD0			; Send Reset Command CMD0 ($40,$00,$00,$00,$00,$95)
	call sd_send_command_null_args
	cp $01				; Command Response should be $01 ("In idle mode")
	jr z,sd_spi_mode_ok
	
	ld a,sd_error_spi_mode_failed
	ret		


; ---- CARD IS IN IDLE MODE -----------------------------------------------------------------------------------


sd_spi_mode_ok:

IF SDHC_SUPPORT

	;ld hl,CMD8_string			; send CMD8 ($48,$00,$00,$01,$aa,$87) to test for SDHC card
	;call sd_send_command_string
	ld a,CMD8
	ld de,$1AA	; 0x1AA means that the card is SDC V2 and can work at voltage range of 2.7 to 3.6 volts.
	call sd_send_command_int_args
	cp $01
	jr nz,sd_sdc_init			; if R1 response is not $01: illegal command: not an SDHC card

	ld b,4
	call sd_read_bytes_to_sector_buffer	; get r7 response (4 bytes)
	ld a,1
	inc hl
	inc hl
	cp (hl)				; we need $01,$aa in response bytes 2 and 3  
	jr z,sd_vrok
	ld a,sd_error_vrange_bad
	ret				

sd_vrok:
	ld a,$aa
	inc hl
	cp (hl)
	jr z,sd_check_pattern_ok
	ld a,sd_error_check_pattern_bad
	ret
	
sd_check_pattern_ok:


;------ SDHC CARD CAN WORK AT 2.7v - 3.6v ----------------------------------------------------------------------
	

	ld bc,8000			; Send SDHC card init

sdhc_iwl:
	ld a,CMD55			; First send CMD55 ($77 00 00 00 00 01) 
	call sd_send_command_null_args
	
	ld hl,ACMD41HCS_string		; Now send ACMD41 with HCS bit set ($69 $40 $00 $00 $00 $01)
	call sd_send_command_string
	jr z,sdhc_init_ok			; when response is $00, card is ready for use	
	bit 2,a
	jr nz,sdhc_if			; if Command Response = "Illegal command", quit
	
	dec bc
	ld a,b
	or c
	jr nz,sdhc_iwl
	
sdhc_if:
	ld a,sd_error_sdhc_init_failed	; if $00 isn't received, fail
	ret
	
sdhc_init_ok:


;------ SDHC CARD IS INITIALIZED --------------------------------------------------------------------------------------

	
	ld a,CMD58			; send CMD58 - read OCR
	call sd_send_command_null_args
		
	ld b,4				; read in OCR
	call sd_read_bytes_to_sector_buffer
	ld a,(hl)
	and $40				; test CCS bit
	rrca
	rrca 
	or @00000010				
	ld (sd_card_info),a			; bit4: Block mode access, bit 0:3 card type (0:MMC,1:SD,2:SDHC)
	xor a				; A = 00, all OK
	ret


ENDIF
	
;-------- NOT AN SDHC CARD, TRY SD INIT ---------------------------------------------------------------------------------

sd_sdc_init:

	ld bc,8000			; Send SD card init

sd_iwl:
	ld a,CMD55			; First send CMD55 ($77 00 00 00 00 01) 
	call sd_send_command_null_args

	ld a,ACMD41			; Now send ACMD41 ($69 00 00 00 00 01)
	call sd_send_command_null_args
	jr z,sd_rdy			; when response is $00, card is ready for use
	
	bit 2,a				
	jr nz,sd_mmc_init			; check command response bit 2, if set = illegal command - try MMC init
	
	dec bc
	ld a,b
	or c
	jr nz,sd_iwl
	
	ld a,sd_error_sd_init_failed		; if $00 isn't received, fail
	ret
	
sd_rdy:
	ld a,1
	ld (sd_card_info),a			; set card type to 1:SD (byte access mode)
	xor a				; A = 0: all ok	
	ret	


;-------- NOT AN SDHC OR SD CARD, TRY MMC INIT ---------------------------------------------------------------------------


sd_mmc_init:

	ld bc,8000			; Send MMC card init and wait for card to initialize

sdmmc_iwl:
	ld a,CMD1
	call sd_send_command_null_args	; send CMD1 ($41 00 00 00 00 01) 
	ret z				; If ZF set, command response in A = 00: Ready,. Card type is default MMC (byte access mode)
	
sd_mnrdy:
	dec bc
	ld a,b
	or c
	jr nz,sdmmc_iwl
	
	ld a,sd_error_mmc_init_failed		; if $00 isn't received, fail	
	ret
