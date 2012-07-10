;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	Send 8 clocks to card, used in various places to keep communications stable
;
;	$Id: sd_send_eight_clocks.asm,v 1.1 2012-07-10 05:55:38 stefano Exp $
;

	XLIB	sd_send_eight_clocks
	
	LIB		sd_send_byte


sd_send_eight_clocks:

	ld a,$ff
	call sd_send_byte
	ret
