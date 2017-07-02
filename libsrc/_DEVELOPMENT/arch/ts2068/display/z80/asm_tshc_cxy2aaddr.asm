; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_cxy2aaddr(uchar x, uchar y)
;
; Attribute address of top pixel row of character square at x,y.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_cxy2aaddr

asm_tshc_cxy2aaddr:

   ; enter : h = valid character y coordinate
   ;         l = valid character x coordinate
   ;
   ; exit  : hl = attribute address corresponding to the top
   ;              pixel row of the character square
   ;
   ; uses  : af, hl

   ld a,h
   rrca
   rrca
   rrca
   and $e0
   or l
   ld l,a
   
   ld a,h
   and $18
   or $60
   ld h,a
   
   ret
