;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;
;	Ported by Stefano Bodrato, 2012
;
;	Returns byte read from card in A
;
;	$Id: sd_get_byte.asm,v 1.3 2015-01-19 01:33:07 pauloscustodio Exp $
;


	PUBLIC	sd_get_byte
	PUBLIC	sd_before_get
	
	EXTERN		sd_send_eight_clocks
	EXTERN	sd_waitserend
	
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
