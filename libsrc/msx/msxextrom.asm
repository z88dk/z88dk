;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	Internal function, call an EXTROM subroutine
;
;
;	$Id: msxextrom.asm,v 1.2 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	msxextrom
	EXTERN	msxrompage

	defc EXTROM = $015f

msxextrom:
         exx
         ex     af,af'       ; store all registers
         ld     hl,EXTROM
         jp	msxrompage
