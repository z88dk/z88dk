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
; $Id: warm_reset.asm,v 1.3 2015-01-19 01:33:00 pauloscustodio Exp $
;


	PUBLIC warm_reset

.warm_reset
	jp	49373
