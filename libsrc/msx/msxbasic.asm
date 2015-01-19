;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	Internal function, call a ROM BASIC subroutine
;
;
;	$Id: msxbasic.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	msxbasic
	EXTERN	msxrompage

	INCLUDE "msxbios.def"

msxbasic:
         exx
         ex     af,af'       ; store all registers
         ld     hl,CALBAS
         jp	msxrompage
