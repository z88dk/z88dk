;
;	Far Call for REX6000
;
;	FarCall function to call code in other mem pages
;	Daniel
;
;	$Id: farcall.asm,v 1.5 2017-01-03 00:11:31 aralbrec Exp $
;

		PUBLIC	farcall
      PUBLIC   _farcall


.farcall	
._farcall
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

