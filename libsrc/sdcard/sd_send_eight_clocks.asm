;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	Send 8 clocks to card, used in various places to keep communications stable
;
;	$Id: sd_send_eight_clocks.asm,v 1.2 2012-09-26 14:15:25 stefano Exp $
;

	XLIB	sd_send_eight_clocks
	
	LIB		sd_send_byte


sd_send_eight_clocks:

	ld a,$ff
	jp sd_send_byte
