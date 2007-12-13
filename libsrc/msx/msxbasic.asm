;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	Internal function, call a ROM BASIC subroutine
;
;
;	$Id: msxbasic.asm,v 1.1 2007-12-13 11:28:42 stefano Exp $
;

	XLIB	msxbasic
	LIB	msxrompage

	defc CALBAS = $0159

msxbasic:
         exx
         ex     af,af'       ; store all registers
         ld     hl,CALBAS
         jp	msxrompage
