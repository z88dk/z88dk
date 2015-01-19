; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Alessandro Poppi
;	ported to z88dk by Stefano Bodrato - Feb 2010
;
;	$Id: cs_low.asm,v 1.2 2015-01-19 01:33:11 pauloscustodio Exp $ 
;
;------------------------------------------------------------------------------------
; CHIP_SELECT LOW subroutine. Destroys no registers. The card to be selected should
; specified in CARD_SELECT (D1 = SLOT1, D0 = SLOT0, active LOW)
;
; used in: 'MMC_SEND_COMMAND', 'MMC_INIT', 'MMC_SEND_BLOCKSIZE'
;------------------------------------------------------------------------------------

	PUBLIC	cs_low
	EXTERN	card_select
	
	INCLUDE "zxmmc.def"


cs_low:
	push af
	ld a,(card_select)
	out (OUT_PORT),a
	pop af
	ret
