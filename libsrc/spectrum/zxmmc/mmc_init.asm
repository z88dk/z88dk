; 
; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Alessandro Poppi
;	ported to z88dk by Stefano Bodrato - Feb 2010
;
;	$Id: mmc_init.asm,v 1.3 2016-06-10 21:28:03 dom Exp $ 
;
;
;-----------------------------------------------------------------------------------------
; MMC SPI MODE initialization. RETURNS ERROR CODE IN A register:
;
; 0 = OK
; 1 = Card RESET ERROR
; 2 = Card INIT ERROR
;
; Destroys AF, B.
;
;
; NOTE: 'pause1' delay needs to be tuned if run on overclocked ZX clones
;
;-----------------------------------------------------------------------------------------
;

	SECTION	code_clib
	PUBLIC	mmc_init
	PUBLIC	_mmc_init
	
	EXTERN		cs_high
	EXTERN		cs_low
	EXTERN		mmc_wait_response
	EXTERN		mmc_write_command

	INCLUDE "zxmmc.def"


mmc_init:
_mmc_init:
	call	cs_high			; set cs high
	ld	b,10			; sends 80 clocks
	ld a,$FF
l_init:
	out (SPI_PORT),a
	djnz l_init
	nop
	
	call	cs_low			; set cs low
	
	ld a,MMC_GO_IDLE_STATE
	call mmc_write_command
	call mmc_wait_response
	
	cp $01				; MMC should respond 01 to this command
	jr nz,mmc_reset_failed		; fail to reset

	ld bc,120			; retry counter*256 (about five seconds @3.5MHz)
mmc_reset_ok:
	call cs_high			; set cs high
	ld a,$FF
	out (SPI_PORT),a		; 8 extra clock cycles
	nop
	nop
	
	call	cs_low			; set cs low
	
	ld a,MMC_SEND_OP_COND		; Sends OP_COND command
	call mmc_write_command
	call mmc_wait_response		; MMC_WAIT_RESPONSE tries to receive a response reading an SPI

	bit 0,a				; D0 SET = initialization still in progress...
	jr z,mmc_init_ok

	djnz mmc_reset_ok		; if no response, tries to send the entire block 254 more times
	dec c
	jr nz,mmc_reset_ok

	ld a,2				; error code for INIT ERROR
	jr mmc_errorx

mmc_init_ok:
	call cs_high			; set cs high
	in a,(SPI_PORT)			; some extra clock cycles
	call pause1
	xor a
	ret
	
mmc_reset_failed:			; MMC Reset error
	ld	a,1
mmc_errorx:
	call	cs_high
	ret


pause1:
	push hl
	ld hl,$8000		; OK for 3.5MHz ONLY (7MHz requires two calls or ld hl,0 and so on)
loop3:	dec hl
	ld a,h
	or l
	jr nz,loop3
	pop hl
	ret

