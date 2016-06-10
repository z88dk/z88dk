; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Alessandro Poppi
;	ported to z88dk by Stefano Bodrato - Feb 2010
;
;	int mmc_command(struct MMC mmc_descriptor, unsigned char command, long parameter)
;
;	$Id: mmc_command.asm,v 1.3 2016-06-10 21:28:03 dom Exp $ 
;
;-----------------------------------------------------------------------------------------
; SEND COMMAND TO MMC
;-----------------------------------------------------------------------------------------
;

	SECTION code_clib
	PUBLIC	mmc_command
	PUBLIC	_mmc_command
	
	EXTERN		mmc_send_command
	EXTERN	__mmc_card_select

	
	INCLUDE "zxmmc.def"

mmc_command:
_mmc_command:
	ld	ix,2
	add	ix,sp
	ld	l,(ix+6)
	ld	h,(ix+7)
	inc	hl		; ptr to MMC mask to be used to select port
	ld	a,(hl)
	ld	(__mmc_card_select), a

;        arg1 = addr_H.BYTE1 (H)
;        arg2 = addr_H.BYTE0 (L)
;        arg3 = addr_L.BYTE1 (D)
;        arg4 = addr_L.BYTE0 (E)

	ld	e,(ix+0)	; LSB
	ld	d,(ix+1)	; .
	ld	l,(ix+2)	; .
	ld	h,(ix+3)	; MSB

	ld	a,(ix+4)
	
	jp	mmc_send_command
