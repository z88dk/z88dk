;
;	Sharp specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int get_psg(int reg);
;
;	Get a PSG register
;
;
;	$Id: get_psg.asm,v 1.1 2013-11-18 10:59:06 stefano Exp $
;

	XLIB	get_psg
	XDEF	psg_patch2
	XDEF	psg_patch3
	
get_psg:

psg_patch2:
    LD	BC,$fffd
	OUT	(C),l
psg_patch3:
    nop
    nop
	in	a,(C)
	ld	l,a
	ret
