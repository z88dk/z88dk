;
; Small C z88 stdlib functions
;
; Return absolute value of long
;
; -----
; $Id: labs_callee.asm,v 1.4 2016-03-04 23:48:12 dom Exp $

PUBLIC labs_callee
PUBLIC _labs_callee
EXTERN l_long_neg
PUBLIC ASMDISP_LABS_CALLEE

.labs_callee
._labs_callee

   pop af
   pop hl
   pop de
   push af

.asmentry
   
   bit 7,d
   ret z
   
   jp l_long_neg

DEFC ASMDISP_LABS_CALLEE = # asmentry - labs_callee
