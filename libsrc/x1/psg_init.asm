;
;	Sharp specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: psg_init.asm,v 1.1 2013-11-15 17:07:47 stefano Exp $
;

	XLIB	psg_init
	
psg_init:

	ld	a,8	; Ch.A  Level
	ld	e,0 ; set to 0
	call outpsg
	inc	a	; Ch.B
	call outpsg
	inc	a	; Ch.C

outpsg:
    LD	BC,1C00H
	OUT	(C),A
	ld	a,e
	inc bc
	OUT	(C),A
	ret

