;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_close_channel(unsigned char ch_number);
;
;
;	$Id: exos_close_channel.asm,v 1.1 2011-03-14 11:36:48 stefano Exp $
;

	XLIB	exos_close_channel

exos_close_channel:

	ld	a,l
	rst   30h
	defb  3
	ld	h,0
	ld	l,a

	ret
