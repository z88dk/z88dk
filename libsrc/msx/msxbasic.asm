;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	Internal function, call a ROM BASIC subroutine
;
;
;	$Id: msxbasic.asm,v 1.4 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msxbasic
	PUBLIC	_msxbasic
	EXTERN	msxrompage

	INCLUDE "msxbios.def"

msxbasic:
_msxbasic:
         exx
         ex     af,af'       ; store all registers
         ld     hl,CALBAS
         jp	msxrompage
