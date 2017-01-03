;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	int sd_write_sector(struct SD_INFO descriptor, long sector, unsigned char *address);
;
;	sd_card_info and card_select must be accessible, 
;	a good place to put them is in the vars declared in the CRT0 stub
;
;	on exit: 0 if all OK or error code
;
;	$Id: sd_write_block_2gb_callee.asm,v 1.5 2017-01-03 00:27:43 aralbrec Exp $
;

	PUBLIC	sd_write_block_2gb_callee
   PUBLIC   _sd_write_block_2gb_callee
	PUBLIC	ASMDISP_SD_WRITE_BLOCK_2GB_CALLEE

	EXTERN	sd_card_info
	EXTERN	card_select

	EXTERN		sd_write_sector_main
	EXTERN		sd_deselect_card
	EXTERN		sd_set_sector_addr_regs
	EXTERN		sd_send_command_current_args
	EXTERN		sd_send_eight_clocks
	EXTERN		sd_send_byte
	EXTERN		sd_get_byte

    INCLUDE "sdcard.def"

sd_write_block_2gb_callee:
_sd_write_block_2gb_callee:

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
	jr nz,write_end			; if SDHC card, linear addressing is not supported
ENDIF

						; ptr to MMC mask to be used to select port
	ld	a,(ix+1)		; or any other hw dependent reference to current slot
	ld	(card_select), a
	ld	a,(ix+2)
	ld	(sd_card_info), a
	
	sub a ; reset carry flag
	call sd_set_sector_addr_regs

	ld a,CMD24			; Send CMD24 write sector command
	call sd_send_command_current_args
	ld a,sd_error_bad_command_response
	jr nz, write_end
	
	call sd_send_eight_clocks		; wait 8 clocks before proceding	

	ld a,$fe
	call sd_send_byte			; send $FE = packet header code

;..............................................................................................	

	exx
	call sd_write_sector_main

;.............................................................................................	

	call sd_get_byte			; get packet response
	and $1f
	srl a
	cp $02
	jr z,sd_wr_ok

sd_write_fail:
	ld a,sd_error_write_failed
	jr write_end

sd_wr_ok:
	ld bc,65535			; read bytes until $ff is received
sd_wcbsy:
	call sd_get_byte			; until that time, card is busy
	cp $ff
	jr nz,sd_busy
	xor a				; A = 0, all OK
	jr write_end
	
sd_busy:
	dec bc
	ld a,b
	or c
	jr nz,sd_wcbsy

sd_card_busy_timeout:
	ld a,sd_error_write_timeout

write_end:
	call sd_deselect_card		; Routines always deselect card on return

;	or a				; If A = 0 on SD routine exit, ZF set on return: No error
	ld h,0
	ld l,a
	ret


DEFC ASMDISP_SD_WRITE_BLOCK_2GB_CALLEE = # asmentry - sd_write_block_2gb_callee
