;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	Internal function, call a ROM BASIC subroutine
;
;
;	$Id: msxbasic.asm,v 1.2 2014-05-19 07:13:09 stefano Exp $
;

	XLIB	msxbasic
	LIB	msxrompage

	INCLUDE "msxbios.def"

msxbasic:
         exx
         ex     af,af'       ; store all registers
         ld     hl,CALBAS
         jp	msxrompage
