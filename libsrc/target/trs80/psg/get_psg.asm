;
;	TRS-80 (EG2000+HT1080) specific routines
;	by Stefano Bodrato, Fall 2015
;
;	int get_psg(int reg);
;
;	Get a PSG register.
;
;
;	$Id: get_psg.asm,v 1.2 2016-06-10 21:13:58 dom Exp $
;

        SECTION code_clib
	PUBLIC	get_psg
	PUBLIC	get_psg2
	PUBLIC	_get_psg
	PUBLIC	_get_psg2
	
get_psg:
_get_psg:
    LD	BC,31
	OUT	(C),l

get_psg2:
_get_psg2:
    LD	c,30
	in	a,(C)

	ld	l,a
	ret
