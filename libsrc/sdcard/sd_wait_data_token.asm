;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	Read SD card until data token ($FE) arrives,
;	if no answer is given after a timeout period, exit keeping ZF not set
;
;	$Id: sd_wait_data_token.asm,v 1.2 2015-01-19 01:33:07 pauloscustodio Exp $
;

	PUBLIC	sd_wait_data_token
	EXTERN		sd_get_byte
	

sd_wait_data_token:

	push bc
	ld bc,8000				
sd_wdt:
	call sd_get_byte			; read until data token ($FE) arrives, ZF set if received
	cp $fe
	jr z,sd_gdt
	dec bc
	ld a,b
	or c
	jr nz,sd_wdt
	inc c				; didn't get a data token, ZF not set
sd_gdt:
	pop bc
	ret
