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
; $Id: cpmzcall.asm,v 1.1 2007-06-03 15:13:06 stefano Exp $
;


	XLIB ZCALL
	
.ZCALL
	jp	$f4fb	; CPMZCALL

