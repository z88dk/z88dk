;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	set HL to ptr to buffer location, sd card addres must be requested already.
;
;	$Id: sd_write_sector_main.asm,v 1.2 2015-01-19 01:33:07 pauloscustodio Exp $
;

	PUBLIC	sd_write_sector_main

	EXTERN	sector_buffer_loc
	
	EXTERN		sd_send_eight_clocks
	EXTERN		sd_send_byte
	EXTERN		sd_get_byte

    INCLUDE "sdcard.def"

sd_write_sector_main:

	ld b,0
sd_wslp:
	ld a,(hl)
	call sd_send_byte
	inc hl
	ld a,(hl)
	call sd_send_byte
	inc hl
	djnz sd_wslp
;.............................................................................................	

	call sd_send_eight_clocks		; send dummy CRC byte 1 ($ff)
	call sd_send_eight_clocks		; send dummy CRC byte 2 ($ff)
	
	ret
