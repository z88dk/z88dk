; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Alessandro Poppi
;	ported to z88dk by Stefano Bodrato - Feb 2010
;
;	$Id: mmc_wait_response.asm,v 1.3 2016-06-10 21:28:03 dom Exp $ 
;
;
;-----------------------------------------------------------------------------------------
; Waits for the MMC to respond. Returns with HL and A = response code; $FF = NO RESPONSE
;
; Responses from CARD are in R1 format for all command except SEND_STATUS.
; When SET, a bit indicates:
;
; D0 = Idle state / init not completed yet
; D1 = Erase Reset
; D2 = Illegal Command
; D3 = Com CRC Error
; D4 = Erase Sequence Error
; D5 = Address Error
; D6 = Parameter Error
; D7 = ALWAYS LOW
;
; Destroys HL,AF.
;-----------------------------------------------------------------------------------------
;

	SECTION code_clib
	PUBLIC	mmc_wait_response
	PUBLIC	_mmc_wait_response

	INCLUDE "zxmmc.def"
	


mmc_wait_response:
_mmc_wait_response:
	push bc
	ld bc,50		; retry counter
l_response:
	in a,(SPI_PORT)		; reads a byte from MMC
	cp $FF			; $FF = no card data line activity
	jr nz,resp_ok
	djnz l_response
	dec c
	jr nz,l_response
resp_ok:
	pop bc
	ld	h,0
	ld	l,a
	ret
