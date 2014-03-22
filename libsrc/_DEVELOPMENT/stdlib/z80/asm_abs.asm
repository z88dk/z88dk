
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
XDEF _l_neg_hl

asm_abs:

   ; enter : hl = int j
   ;
   ; exit  : hl = abs(j)
   ;
   ; uses  : af, hl, carry unaffected
   
   bit 7,h
   ret z

_l_neg_hl:

   ; negate hl
   ;
   ; enter : hl = int
   ;
   ; exit  : hl = -hl
   ;
   ; uses  : af, hl, carry unaffected

   ld a,l
   cpl
   ld l,a
   
   ld a,h
   cpl
   ld h,a
   
   inc hl
   ret
