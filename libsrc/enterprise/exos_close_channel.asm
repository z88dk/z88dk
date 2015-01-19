;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_close_channel(unsigned char ch_number);
;
;
;	$Id: exos_close_channel.asm,v 1.3 2015-01-19 01:32:42 pauloscustodio Exp $
;

	PUBLIC	exos_close_channel

exos_close_channel:

	ld	a,l
	rst   30h
	defb  3
	ld	h,0
	ld	l,a

	ret
