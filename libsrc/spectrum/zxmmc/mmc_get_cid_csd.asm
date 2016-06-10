; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Alessandro Poppi
;	ported to z88dk by Stefano Bodrato - Feb 2010
;	
;
;	$Id: mmc_get_cid_csd.asm,v 1.3 2016-06-10 21:28:03 dom Exp $ 
;
;--------------------------------------------------------------------------------------------------------
; READ MMC CID subroutine. Data is stored at address (HL), command in A (MMC_READ_CID or MMC_READ_CSD).
;
; Returns error code in A and HL register:
; 0 = no error
; 1 = Read CID command error
; 2 = no wait_data token from MMC
;
;--------------------------------------------------------------------------------------------------------
;

	SECTION code_clib
	PUBLIC	mmc_get_cid_csd
	PUBLIC	_mmc_get_cid_csd
	
	EXTERN		mmc_waitdata_token
	EXTERN		mmc_send_command
	EXTERN		cs_high

	
	INCLUDE "zxmmc.def"

	
mmc_get_cid_csd:
_mmc_get_cid_csd:

	ld	(hl),0			; kill the OEM ID, just to touch the CID a little
	push hl
	ld hl,0
	ld d,l
	ld e,l
	;ld b,$FF
	
	call mmc_send_command
	pop hl

	cp 0
	jr z,cmd_cidok			; MMC_SEND_COMMAND reports 0 (ok) or MMC error code
	push af				; error code on STACK
	jr cid_exit
cmd_cidok:
	call mmc_waitdata_token
	cp $FE
	jr z,waitda_cid_ok
	ld a,2
	push af
	jr cid_exit

waitda_cid_ok:
	ld b,18				; 16 bytes + CRC?
	ld c,SPI_PORT

	inir

	xor a
	push af
cid_exit:
	call cs_high			; set cs high
	in a,(SPI_PORT)
	pop af				; error code
	
	ld	h,0
	ld	l,a
	ret
