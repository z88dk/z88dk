;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 19/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; This function is linked only in the CP/M extension version
; it calls the ROM functions via the CP/M facility
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; Used internally only
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: cpmzcall.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;


	PUBLIC ZCALL
	
.ZCALL
	jp	$f4fb	; CPMZCALL

