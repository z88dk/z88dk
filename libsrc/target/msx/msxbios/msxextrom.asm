;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	Internal function, call an EXTROM subroutine
;
;
;	$Id: msxextrom.asm,v 1.3 2016-06-19 21:00:56 dom Exp $
;

        SECTION   code_clib
	PUBLIC	msxextrom
	EXTERN	msxrompage

	defc EXTROM = $015f

msxextrom:
         exx
         ex     af,af'       ; store all registers
         ld     hl,EXTROM
         jp	msxrompage
