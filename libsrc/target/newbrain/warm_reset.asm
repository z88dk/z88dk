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
; $Id: warm_reset.asm,v 1.4 2016-06-19 20:33:40 dom Exp $
;

        SECTION code_clib
	PUBLIC warm_reset
	PUBLIC _warm_reset

.warm_reset
._warm_reset
	jp	49373
