;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 19/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; This function is linked only in the non-CP/M version
; it calls the ROM functions via the standard rst entry
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; Used internally only
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: zcall.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;


	PUBLIC ZCALL
	
.ZCALL
	jp	$20	; ZCALL

