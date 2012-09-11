;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	Init SD card communications
;	Input: HL = card slot number
;
;	$Id: sd_initialize.asm,v 1.2 2012-09-11 13:09:39 stefano Exp $
;

	XLIB	sd_initialize
	
	LIB		sd_init_main
	LIB		sd_power_off
	LIB		sd_spi_port_fast
	LIB		sd_read_cid
	LIB		sd_read_csd
	LIB		sd_deselect_card


sd_initialize:
	ld	a,l
	call sd_init_main
	or a				; if non-zero returned in A, there was an error
	jr z,sd_inok
	call sd_power_off			; if init failed shut down the SPI port
	ld hl,-1
	ret

sd_inok:
	call sd_spi_port_fast		; on initializtion success -  switch to fast clock 

	call sd_read_cid			; and read CID/CSD
	jr nz,sd_done
	push hl				; cache the location of the ID string
	call sd_read_csd
	pop hl

sd_done:
	call sd_deselect_card		; Routines always deselect card on return
	or a				; If A = 0 on SD routine exit, ZF set on return: No error
	ret z
	ld	hl,-1
	ret				; if A <> set carry flag			 

