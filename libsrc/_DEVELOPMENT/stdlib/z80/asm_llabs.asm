
; ===============================================================
; May 2016
; ===============================================================
; 
; long long labs(long long j)
;
; Return absolute value of j.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_llabs

EXTERN l_neg_64_dehldehl

asm_llabs:

   ; enter : dehl'dehl = long long
   ;
   ; exit  : dehl'dehl = abs(dehl'dehl)
   ;
   ; uses  : af, de, hl, de', hl', carry unaffected
   
   exx
   bit 7,d
   exx
   ret z
   
   jp l_neg_64_dehldehl
