
; ===============================================================
; Nov 2013
; ===============================================================
; 
; long labs(long j)
;
; Return absolute value of j.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_labs

EXTERN l_neg_dehl

asm_labs:

   ; enter : dehl = long
   ;
   ; exit  : dehl = abs(dehl)
   ;
   ; uses  : af, de, hl, carry unaffected
   
   bit 7,d
   ret z
   
   jp l_neg_dehl
