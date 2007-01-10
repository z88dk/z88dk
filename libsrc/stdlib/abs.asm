;
; Small C z88 Misc functions
;
; Return absolute value 
; This is interesting method, but so much quicker than what a compiled
; version would do..
;
; -----
; $Id: abs.asm,v 1.5 2007-01-10 08:17:06 aralbrec Exp $

XLIB abs
LIB l_neg

; FASTCALL

.abs

   bit 7,h
   ret z
   jp l_neg
