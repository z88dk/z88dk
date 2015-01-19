;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	set HL to ptr to buffer location, sd card addres must be requested already.
;
;	$Id: sd_read_sector_main.asm,v 1.4 2015-01-19 01:33:07 pauloscustodio Exp $
;

	PUBLIC	sd_read_sector_main


    INCLUDE "sdcard.def"
    INCLUDE "osca.def"


;--------------------------------------------------------------------------------------------------
; SD Card READ SECTOR code begins...
;--------------------------------------------------------------------------------------------------
	
sd_read_sector_main:

; 512 bytes are returned in sector buffer

	ld c,sys_spi_port
	ld b,0
	ld a,$ff
	out (sys_spi_port),a		; send read clocks for first byte
	nop
	nop
	nop
sd_orsl1:
	nop				; 4 cycles
	ini				; 16 cycles (c)->(HL), HL+1, B1-1
	out (sys_spi_port),a		; 11 cycles - read clocks (requires 16 cycles)
	jp nz,sd_orsl1			; 10 cycles
sd_orsl2:
	nop				; 4 cycles
	ini				; 16 cycles (c)->(HL), HL+1, B1-1
	out (sys_spi_port),a		; 11 cycles - read clocks (requires 16 cycles)
	jp nz,sd_orsl2			; 10 cycles
	nop				; allow the 'extra' read clocks to end (cyc byte 1)
	nop
	out (sys_spi_port),a		; 8 more clocks (skip crc byte 2)
	nop
	nop
	nop
	nop

;..................................................................................................	
;	ld b,0				; unoptimized sector read
;	call sd_read_bytes_to_sector_buffer
;	inc h
;	ld b,0
;	call read_bytes
;	call sd_get_byte			; read CRC byte 1
;	call sd_get_byte			; read CRC byte 2
;...................................................................................................

	xor a				; A = 0: all ok
	ret
