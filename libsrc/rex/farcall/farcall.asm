;
;	Far Call for REX6000
;
;	FarCall function to call code in other mem pages
;	Daniel
;
;	$Id: farcall.asm,v 1.3 2002-04-10 20:16:25 dom Exp $
;

		XLIB	farcall


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

