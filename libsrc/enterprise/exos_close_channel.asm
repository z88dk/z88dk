;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_close_channel(unsigned char ch_number);
;
;
;	$Id: exos_close_channel.asm,v 1.2 2011-03-15 14:34:08 stefano Exp $
;

	XLIB	exos_close_channel

exos_close_channel:

	ld	a,l
	rst   30h
	defb  3
	ld	h,0
	ld	l,a

	ret
