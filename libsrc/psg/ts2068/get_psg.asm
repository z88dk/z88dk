;
;	Timex 2068 specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int get_psg(int reg);
;
;	Get a PSG register
;
;
;	$Id: get_psg.asm,v 1.1 2013-11-21 09:03:38 stefano Exp $
;

	XLIB	get_psg
	XDEF	psg_patch2
	XDEF	psg_patch3
	
get_psg:

psg_patch2:
    LD	BC,$f5
	OUT	(C),l
	inc c
	in	a,(C)
	ld	l,a
	ret
