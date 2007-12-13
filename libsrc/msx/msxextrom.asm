;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	Internal function, call an EXTROM subroutine
;
;
;	$Id: msxextrom.asm,v 1.1 2007-12-13 11:28:42 stefano Exp $
;

	XLIB	msxextrom
	LIB	msxrompage

	defc EXTROM = $015f

msxextrom:
         exx
         ex     af,af'       ; store all registers
         ld     hl,EXTROM
         jp	msxrompage
