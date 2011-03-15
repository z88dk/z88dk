;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_channel_read_status(unsigned char ch_number);
;
;
;	$Id: exos_channel_read_status.asm,v 1.1 2011-03-15 14:34:08 stefano Exp $
;

	XLIB	exos_channel_read_status

exos_channel_read_status:

	ld	a,l
	rst   30h
	defb  9
	ld	h,0
	ld	l,c

	ret
