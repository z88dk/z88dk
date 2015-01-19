; 
; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Alessandro Poppi
;	ported to z88dk by Stefano Bodrato - Feb 2010
;
;	$Id: mmc_write_command.asm,v 1.2 2015-01-19 01:33:11 pauloscustodio Exp $ 
;
;-----------------------------------------------------------------------------------------
; Sends a command with parameters = 00 and checksum = $95. 
;-----------------------------------------------------------------------------------------
;

	PUBLIC	mmc_write_command
	
	INCLUDE "zxmmc.def"


mmc_write_command:
	push bc
	out (SPI_PORT),a	; sends the command
	ld b,4
	xor a
l_sendc0:
	out (SPI_PORT),a	; then sends four "00" bytes (parameters = NULL)
	djnz l_sendc0
	ld a,$95		; $95 is only needed when the CARD INIT is being performed,
	nop
	out (SPI_PORT),a	; then this byte is ignored.
	pop bc
	ret
