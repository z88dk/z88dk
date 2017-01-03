;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	int sd_read_sector(struct SD_INFO descriptor, long sector, unsigned char *address);
;
;	sd_card_info and card_select must be accessible, 
;	a good place to put them is in the vars declared in the CRT0 stub
;
;	on exit: 0 if all OK or error code
;
;	$Id: sd_read_block_2gb_callee.asm,v 1.5 2017-01-03 00:27:43 aralbrec Exp $
;

	PUBLIC	sd_read_block_2gb_callee
   PUBLIC   _sd_read_block_2gb_callee
	PUBLIC	ASMDISP_SD_READ_BLOCK_2GB_CALLEE

	EXTERN	sd_card_info
	EXTERN	card_select
	
	EXTERN		sd_read_sector_main
	EXTERN		sd_set_sector_addr_regs
	EXTERN		sd_send_command_current_args
	EXTERN		sd_wait_data_token
	EXTERN		sd_deselect_card

    INCLUDE "sdcard.def"
    INCLUDE "osca.def"

sd_read_block_2gb_callee:
_sd_read_block_2gb_callee:
	pop af	; ret addr
	pop hl	; dst addr
	exx
	pop hl	; sector pos lsb
	pop de	; sector pos msb
	pop ix	; SD_INFO struct
	push af

.asmentry

IF SDHC_SUPPORT
	ld a,(sd_card_info)
	and $10
	ld a,sd_error_too_big
	jr nz,read_end			; if SDHC card, linear addressing is not supported
ENDIF

						; ptr to MMC mask to be used to select port
	ld	a,(ix+1)		; or any other hw dependent reference to current slot
	ld	(card_select), a
	ld	a,(ix+2)
	ld	(sd_card_info), a
	
	sub a ; reset carry flag
	call sd_set_sector_addr_regs

	ld a,CMD17			; Send CMD17 read sector command
	call sd_send_command_current_args
	ld a,sd_error_bad_command_response
	jr nz,read_end		; if ZF set command response is $00	

	call sd_wait_data_token		; wait for the data token
	ld a,sd_error_data_token_timeout
	jr nz,read_end		; ZF set if data token reeceived

;..............................................................................................	

	exx
	call sd_read_sector_main

;..............................................................................................	

read_end:
	call sd_deselect_card		; Routines always deselect card on return

	ld h,0
	ld l,a
	ret


DEFC ASMDISP_SD_READ_BLOCK_2GB_CALLEE = # asmentry - sd_read_block_2gb_callee
