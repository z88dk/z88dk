;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 05/04/2007
;
;
; warm reset: foolishly jump to BASIC entry
;
;
;
; $Id: warm_reset.asm,v 1.2 2007-06-03 15:13:06 stefano Exp $
;


	XLIB warm_reset

.warm_reset
	jp	49373
