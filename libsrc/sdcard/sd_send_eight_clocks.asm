;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	Send 8 clocks to card, used in various places to keep communications stable
;
;	$Id: sd_send_eight_clocks.asm,v 1.3 2015-01-19 01:33:07 pauloscustodio Exp $
;

	PUBLIC	sd_send_eight_clocks
	
	EXTERN		sd_send_byte


sd_send_eight_clocks:

	ld a,$ff
	jp sd_send_byte
