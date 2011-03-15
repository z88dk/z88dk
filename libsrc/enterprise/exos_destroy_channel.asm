;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_destroy_channel(unsigned char ch_number);
;
;
;	$Id: exos_destroy_channel.asm,v 1.2 2011-03-15 14:34:08 stefano Exp $
;

	XLIB	exos_destroy_channel

exos_destroy_channel:

	ld	a,l
	rst   30h
	defb  4
	ld	h,0
	ld	l,a

	ret
