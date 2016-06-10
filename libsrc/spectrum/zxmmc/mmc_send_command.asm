; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Alessandro Poppi
;	ported to z88dk by Stefano Bodrato - Feb 2010
;
;	$Id: mmc_send_command.asm,v 1.3 2016-06-10 21:28:03 dom Exp $ 
;
;-----------------------------------------------------------------------------------------
; SEND COMMAND TO MMC subroutine with trailing CRC7 checkum
;
; A = COMMAND CODE;
; H, L, D, E = 32 bit parameter (MSB ... LSB);
;
; Sends a CRC7 checksum
;
; RETURNS: 0 = OK; != 0 = MMC error code
;
; On OK, the CHIP SELECT will be LOW on exit
; On error, the CHIP SELECT will be deasserted on exit
;
;-----------------------------------------------------------------------------------------


	SECTION code_clib
	PUBLIC	mmc_send_command
	PUBLIC	_mmc_send_command
	EXTERN		mmc_wait_response
	EXTERN		cs_high
	EXTERN		cs_low
	EXTERN		clock32

	INCLUDE "zxmmc.def"

	
mmc_send_command:
_mmc_send_command:

	ld c,a
	call cs_high			; cs high
	call clock32
	;; nop				; Why another NOP ?
	call cs_low			; cs low
	ld a,c				; command code is the first byte to be sent

	ld c,0				; init crc counter
	push hl
	call crc7_out		; command
	pop hl
	ld	a,h
	call crc7_out		; long parameter
	ld	a,l
	call crc7_out
	ld	a,d
	call crc7_out
	ld	a,e
	call crc7_out
	
	sla c				; crc = (crc << 1) | 1;
	ld a,1
	or c
	out (SPI_PORT),a	; send crc7 checksum byte

	
;	out (SPI_PORT),a
;	ld a,h
;	nop
;	out (SPI_PORT),a
;	ld a,l
;	nop
;	out (SPI_PORT),a
;	ld a,d
;	nop
;	out (SPI_PORT),a
;	ld a,e
;	nop
;	out (SPI_PORT),a
;	;;ld a,$ff
;	ld	a,b
;	nop
;	out (SPI_PORT),a

	call mmc_wait_response		; waits for the MMC to reply != $FF
	cp 0
	jr nz,mmc_commande

	;;ld	hl,0
	ret				; 0 = no error


mmc_commande:
	push af				; saves the error code
	call cs_high			; set cs high
	in a,(SPI_PORT)
	pop af

	;;ld	h,0
	;;ld	l,a
	ret				; returns the error code got from MMC


crc7_out:
	out (SPI_PORT),a

	ld b,8		; 8 bits
crcloop:
	sla c		; crc <<= 1;
	ld	h,a
	xor c
	and $80		; if ((byte & 0x80) ^ (crc & 0x80)) ..
	jr z,isz
	ld a,9		; .. then crc ^= 0x09
	xor c
	ld c,a
isz:
	ld a,h
	rla			; byte <<=1;
	djnz crcloop
	ret
