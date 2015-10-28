;
;	TRS-80 (EG2000+HT1080) specific routines
;	by Stefano Bodrato, Fall 2015
;
;	int get_psg(int reg);
;
;	Get a PSG register.
;
;
;	$Id: get_psg.asm,v 1.1 2015-10-28 07:21:45 stefano Exp $
;

	PUBLIC	get_psg
	PUBLIC	get_psg2
	
get_psg:
    LD	BC,31
	OUT	(C),l

get_psg2:
    LD	c,30
	in	a,(C)

	ld	l,a
	ret
