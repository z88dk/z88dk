; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_cy2aaddr(uchar row)
;
; Character y coordinate to attribute address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_cy2aaddr

asm_tshc_cy2aaddr:

   ; enter :  l = valid character y coordinate
   ;
   ; exit  : hl = attribute address of character coordinate row = y, x = 0
   ;
   ; uses  : af, hl

   ld a,l
   and $18
   or $60
   ld h,a
   
   ld a,l
   rrca
   rrca
   rrca
   and $e0
   ld l,a
   
   ret
