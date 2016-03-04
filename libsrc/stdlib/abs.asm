;
; Small C z88 Misc functions
;
; Return absolute value 
; This is interesting method, but so much quicker than what a compiled
; version would do..
;
; -----
; $Id: abs.asm,v 1.7 2016-03-04 23:48:12 dom Exp $

PUBLIC abs
PUBLIC _abs
EXTERN l_neg

; FASTCALL

.abs
._abs

   bit 7,h
   ret z
   jp l_neg
