;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	set HL to ptr to buffer location, sd card addres must be requested already.
;
;	$Id: sd_read_sector_main.asm,v 1.2 2012-09-13 07:24:17 stefano Exp $
;

	XLIB	sd_read_sector_main

	LIB		sd_read_bytes
	LIB		sd_get_byte

    INCLUDE "sdcard.def"

;--------------------------------------------------------------------------------------------------
; SD Card READ SECTOR code begins...
;--------------------------------------------------------------------------------------------------
	
sd_read_sector_main:

; 512 bytes are returned in sector buffer

	ld b,0				; unoptimized sector read
	call sd_read_bytes
	inc h
	ld b,0
	call sd_read_bytes
	call sd_get_byte			; read CRC byte 1
	call sd_get_byte			; read CRC byte 2

	xor a				; A = 0: all ok
	ret
