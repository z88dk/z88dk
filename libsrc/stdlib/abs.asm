;
; Small C z88 Misc functions
;
; Return absolute value 
; This is interesting method, but so much quicker than what a compiled
; version would do..
;
; -----
; $Id: abs.asm,v 1.6 2015-01-19 01:33:22 pauloscustodio Exp $

PUBLIC abs
EXTERN l_neg

; FASTCALL

.abs

   bit 7,h
   ret z
   jp l_neg
