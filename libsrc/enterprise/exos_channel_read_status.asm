;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_channel_read_status(unsigned char ch_number);
;
;
;	$Id: exos_channel_read_status.asm,v 1.3 2016-06-19 20:17:32 dom Exp $
;

        SECTION code_clib
	PUBLIC	exos_channel_read_status
	PUBLIC	_exos_channel_read_status

exos_channel_read_status:
_exos_channel_read_status:

	ld	a,l
	rst   30h
	defb  9
	ld	h,0
	ld	l,c

	ret
