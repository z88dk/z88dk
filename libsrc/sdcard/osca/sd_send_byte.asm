;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;
;	Ported by Stefano Bodrato, 2012
;
;	Put byte to send to card in A
;	C holds the checksum, do not alter it in a command sequence
;   Corrupts H and B
;
;	$Id: sd_send_byte.asm,v 1.5 2015-01-19 01:33:07 pauloscustodio Exp $
;


	PUBLIC	sd_send_byte
	PUBLIC	sd_waitserend
	
    INCLUDE "osca.def"


sd_send_byte:
	out (sys_spi_port),a		; send byte to serializer

sd_waitserend:
	in a,(sys_hw_flags)			; wait for serialization to end
	bit 6,a
	jr nz,sd_waitserend
	ret
