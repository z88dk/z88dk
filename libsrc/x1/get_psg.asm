;
;	Sharp specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int get_psg(int reg);
;
;	Get a PSG register
;
;
;	$Id: get_psg.asm,v 1.2 2013-11-15 17:07:47 stefano Exp $
;

	XLIB	get_psg
	
get_psg:

	ld	a,l

    LD	BC,1C00H
	OUT	(C),A
	inc bc
	IN	a,(C)
	ld	l,a
	ret
