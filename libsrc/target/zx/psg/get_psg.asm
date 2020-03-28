;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int get_psg(int reg);
;
;	Get a PSG register
;
;
;	$Id: get_psg.asm,v 1.3 2016-06-10 21:13:58 dom Exp $
;

	SECTION code_clib
	PUBLIC	get_psg
	PUBLIC	_get_psg

	EXTERN	__psg_select_and_read_port
	
get_psg:
_get_psg:
	ld	bc,(__psg_select_and_read_port)
	out	(c),l
	in	a,(c)
	ld	l,a
	ret
