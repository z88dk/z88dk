;
; Small C z88 Misc functions
;
; Return absolute value 
; This is interesting method, but so much quicker than what a compiled
; version would do..
;
; -----
; $Id: abs.asm,v 1.4 2007-01-03 22:23:48 aralbrec Exp $

XLIB abs
LIB l_neg
XDEF ASMDISP_ABS

; FASTCALL

.abs

   bit 7,h
   ret z
   jp l_neg
   
DEFC ASMDISP_ABS = 0
