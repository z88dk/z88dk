
; ===============================================================
; Nov 2013
; ===============================================================
; 
; int abs(int j)
;
; Return absolute value of j.
;
; ===============================================================

XLIB asm_abs

LIB l_neg_hl

asm_abs:

   ; enter : hl = int j
   ;
   ; exit  : hl = abs(j)
   ;
   ; uses  : af, hl
   
   bit 7,h
   ret z
   
   jp l_neg_hl
