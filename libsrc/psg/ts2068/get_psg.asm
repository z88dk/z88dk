;
;	Timex 2068 specific routines
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
	PUBLIC	psg_patch2
	PUBLIC	psg_patch3
	
get_psg:
_get_psg:

psg_patch2:
    LD	BC,$f5
	OUT	(C),l
	inc c
	in	a,(C)
	ld	l,a
	ret
