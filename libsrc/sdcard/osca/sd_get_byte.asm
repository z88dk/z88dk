;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;
;	Ported by Stefano Bodrato, 2012
;
;	Returns byte read from card in A
;
;	$Id: sd_get_byte.asm,v 1.1 2012-07-10 05:55:38 stefano Exp $
;


	XLIB	sd_get_byte
	LIB		sd_send_eight_clocks
	;XREF	sd_waitserend
	
    INCLUDE "osca.def"


sd_get_byte:

	;ld a,$ff
	;out (sys_spi_port),a		; send 8 clocks
	;
	;call sd_waitserend
	
	call sd_send_eight_clocks

	in a,(sys_spi_port)			; read the contents of the shift register
	ret
