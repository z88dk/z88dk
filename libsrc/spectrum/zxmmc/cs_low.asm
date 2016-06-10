; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Alessandro Poppi
;	ported to z88dk by Stefano Bodrato - Feb 2010
;
;	$Id: cs_low.asm,v 1.3 2016-06-10 21:28:03 dom Exp $ 
;
;------------------------------------------------------------------------------------
; CHIP_SELECT LOW subroutine. Destroys no registers. The card to be selected should
; specified in CARD_SELECT (D1 = SLOT1, D0 = SLOT0, active LOW)
;
; used in: 'MMC_SEND_COMMAND', 'MMC_INIT', 'MMC_SEND_BLOCKSIZE'
;------------------------------------------------------------------------------------

	SECTION	code_clib
	PUBLIC	cs_low
	EXTERN	__mmc_card_select
	
	INCLUDE "zxmmc.def"


cs_low:
	push af
	ld a,(__mmc_card_select)
	out (OUT_PORT),a
	pop af
	ret
