; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Alessandro Poppi
;	ported to z88dk by Stefano Bodrato - Feb 2010
;
;	int mmc_load(slot, struct MMC mmc_descriptor)
;		result: 0-OK, 
;
;	$Id: mmc_load.asm,v 1.3 2016-06-10 21:28:03 dom Exp $ 
;
;-----------------------------------------------------------------------------------------
; Init MMC interface. look for card, etc..
;-----------------------------------------------------------------------------------------
;

	SECTION	code_clib
	PUBLIC	mmc_load
	PUBLIC	_mmc_load
	
	EXTERN	__mmc_card_select

	EXTERN		mmc_get_cid_csd
	EXTERN		mmc_init

	
	INCLUDE "zxmmc.def"


mmc_load:
_mmc_load:
	di
	in a,(RXREG)		; clears UART RX register

	pop	bc
	pop	hl		; ptr to MMC struct
	pop	de		; slot number
	push de
	push hl
	push bc
	
	ld	a,e

	ld	(hl),a			; Current slot number (human readable)
	inc	hl

	and	a
	ld	a,MMC_0			; ENABLE SLOT 0 (also disables NMI on RS-232 byte reception (D3 low))
	jr	z,encoded
	ld	a,MMC_1			; ENABLE SLOT 1 (also disables NMI on RS-232 byte reception (D3 low))
encoded:

	ld	(hl),a			; Current MMC port
	inc	hl				; point to CID

	ld (__mmc_card_select),a

	call sd_check		; check if SD/MMC is present
	ei

	ld	h,0
	ld	l,a

	ret

	
	
	
;-------------------------------------------------------------------------------------------
; This subroutine should be called at power-on or when a MMC has been inserted.
; It tries to get the MMC CID (writing at the provided HL pointer) and, in case of failure,
; it calls the INIT procedure then tries again.
;
; Returns A = 0 if OK, or 1 = error (no MMC found or MMC error)
;-------------------------------------------------------------------------------------------
;
	

sd_check:
	push hl
	ld	a,MMC_READ_CID
	call mmc_get_cid_csd		; try to read the MMC CID INFO --> (HL)
	pop hl
	cp 0
	jr nz,no_ok
	ld	de,16
	add	hl,de
	ld	a,MMC_READ_CSD
	jp mmc_get_cid_csd		; load also CSD info and return

no_ok:
	cp 255				; card is probably not in SPI mode
	jr z,need_init

	bit 0,a				; IDLE/still initializing bit
	jr nz,need_init

	ld a,3				; unknown response: exit
	ret

need_init:
	push hl
	call mmc_init
	pop hl
	cp 0
	ret nz				; INIT error: MMC not detected.

	;ld de,BLOCKSIZE
	ld de,512
	call mmc_send_blocksize
	jr sd_check

	
	
	
;-----------------------------------------------------------------------------------------
; SENDS BLOCK_SIZE COMMAND TO MMC.
;
; Parameters: DE = nbytes. Destroys AF.
;-----------------------------------------------------------------------------------------


	EXTERN		cs_high
	EXTERN		cs_low

mmc_send_blocksize:
	call	cs_low			; set cs low
	ld a,MMC_SET_BLOCK_SIZE
	out (SPI_PORT),a
	xor a
	nop
	out (SPI_PORT),a
	nop
	nop
	out (SPI_PORT),a
	ld a,d
	nop
	out (SPI_PORT),a
	ld a,e
	nop
	out (SPI_PORT),a
	ld a,$ff			; fake checksum
	nop
	out (SPI_PORT),a
	nop
	nop

	in a,(SPI_PORT)
	nop
	nop
	in a,(SPI_PORT)
	nop
	nop
	call	cs_high
	
	ret
