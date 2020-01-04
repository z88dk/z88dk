;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_destroy_channel(unsigned char ch_number);
;
;
;	$Id: exos_destroy_channel.asm,v 1.4 2016-06-19 20:17:32 dom Exp $
;

        SECTION code_clib
	PUBLIC	exos_destroy_channel
	PUBLIC	_exos_destroy_channel

exos_destroy_channel:
_exos_destroy_channel:

	ld	a,l
	rst   30h
	defb  4
	ld	h,0
	ld	l,a

	ret
