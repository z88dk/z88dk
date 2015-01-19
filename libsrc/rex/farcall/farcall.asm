;
;	Far Call for REX6000
;
;	FarCall function to call code in other mem pages
;	Daniel
;
;	$Id: farcall.asm,v 1.4 2015-01-19 01:33:06 pauloscustodio Exp $
;

		PUBLIC	farcall


.farcall	
	pop	hl		;return addr
	pop	bc		;Lib page
	pop	de		;LibMain addr
	push	de
	push	bc
	push	hl
	in	a,(1)
	ld	h,0
	ld	l,a
	push	hl
	push	de
	ld	a,c
	jp	$26ea

