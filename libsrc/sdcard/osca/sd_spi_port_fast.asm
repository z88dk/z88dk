;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;
;	Ported by Stefano Bodrato, 2012
;
;	Switch the sdcard to fast clock
;
;	$Id: sd_spi_port_fast.asm,v 1.2 2015-01-19 01:33:07 pauloscustodio Exp $
;


	PUBLIC	sd_spi_port_fast
    INCLUDE "osca.def"


sd_spi_port_fast:
	
	push af
	ld a,@11000000			; (6) = 1 FPGA Output enabled, (7) = 1: 8MHz SPI clock

	out (sys_sdcard_ctrl1),a
	pop af
	ret
