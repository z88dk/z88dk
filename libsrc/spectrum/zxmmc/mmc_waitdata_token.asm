; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Alessandro Poppi
;	ported to z88dk by Stefano Bodrato - Feb 2010
;
;	$Id: mmc_waitdata_token.asm,v 1.1 2010-03-12 15:21:14 stefano Exp $ 
;
;
;-----------------------------------------------------------------------------------------
; WAIT FOR DATA TOKEN ($FE) subroutine (calls MMC_WAIT_RESPONSE up to 256 times)
; Returns with A = code read from MMC (ok if $FE). Destroys AF.
;-----------------------------------------------------------------------------------------

	XLIB	mmc_waitdata_token
	LIB		mmc_wait_response

	INCLUDE "zxmmc.def"
	

mmc_waitdata_token:
	push bc
	ld b,10				; retry counter
mmc_waitl:
	push hl
	call mmc_wait_response
	pop hl
	cp $FE				; waits for the MMC to reply $FE (DATA TOKEN)
	jr z,exit_wda
	cp $FF				; but if not $FF, exits immediately (error code from MMC)
	jr nz,exit_wda
	djnz mmc_waitl
exit_wda:
	pop bc
	ret
