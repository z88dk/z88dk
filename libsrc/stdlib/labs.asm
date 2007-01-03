;
; Small C z88 stdlib functions
;
; Return absolute value of long
;
; -----
; $Id: labs.asm,v 1.4 2007-01-03 22:23:48 aralbrec Exp $

XLIB labs
LIB l_long_neg
XDEF ASMDISP_LABS

.labs

   pop af
   pop hl
   pop de
   push de
   push hl
   push af

.asmentry
   
   bit 7,d
   ret z
   
   jp l_long_neg

DEFC ASMDISP_LABS = asmentry - labs
