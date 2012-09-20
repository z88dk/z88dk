;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;
;	Ported by Stefano Bodrato, 2012
;
;	Returns byte read from card in A
;
;	$Id: sd_get_byte.asm,v 1.2 2012-09-20 21:13:16 stefano Exp $
;


	XLIB	sd_get_byte
	XDEF	sd_before_get
	
	LIB		sd_send_eight_clocks
	XREF	sd_waitserend
	
    INCLUDE "osca.def"


sd_get_byte:

	call sd_before_get
	;call sd_send_eight_clocks

	in a,(sys_spi_port)			; read the contents of the shift register
	ret

sd_before_get:
	ld a,$ff
	out (sys_spi_port),a		; send 8 clocks
	
	jp sd_waitserend
