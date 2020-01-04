;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_close_channel(unsigned char ch_number);
;
;
;	$Id: exos_close_channel.asm,v 1.4 2016-06-19 20:17:32 dom Exp $
;

        SECTION code_clib
	PUBLIC	exos_close_channel
	PUBLIC	_exos_close_channel

exos_close_channel:
_exos_close_channel:

	ld	a,l
	rst   30h
	defb  3
	ld	h,0
	ld	l,a

	ret
