;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;
;	Ported by Stefano Bodrato, 2012
;
;	Put byte to send to card in A
;
;	$Id: sd_send_byte.asm,v 1.2 2012-09-20 21:13:16 stefano Exp $
;


	XLIB	sd_send_byte
	XDEF	sd_waitserend
	
    INCLUDE "osca.def"


sd_send_byte:


	out (sys_spi_port),a		; send byte to serializer
	
sd_waitserend:
	in a,(sys_hw_flags)			; wait for serialization to end
	bit 6,a
	jr nz,sd_waitserend
	ret
