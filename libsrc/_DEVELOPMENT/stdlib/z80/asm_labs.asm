
; ===============================================================
; Nov 2013
; ===============================================================
; 
; long labs(long j)
;
; Return absolute value of j.
;
; ===============================================================

XLIB asm_labs
XDEF l_neg_dehl

asm_labs:

   ; enter : dehl = long
   ;
   ; exit  : dehl = abs(dehl)
   ;
   ; uses  : af, de, hl, carry unaffected
   
   bit 7,d
   ret z
   
l_neg_dehl:

   ; negate dehl
   ;
   ; enter : dehl = long
   ;
   ; exit  : dehl = -long
   ;
   ; uses  : af, de, hl, carry unaffected
   
   ld a,l
   cpl
   ld l,a
   
   ld a,h
   cpl
   ld h,a
   
   ld a,e
   cpl
   ld e,a
   
   ld a,d
   cpl
   ld d,a
   
   inc l
   ret nz
   
   inc h
   ret nz
   
   inc de
   ret
