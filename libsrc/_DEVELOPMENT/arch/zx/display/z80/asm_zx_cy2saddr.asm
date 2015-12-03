
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_cy2saddr(uchar row)
;
; Character y coordinate to screen address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_cy2saddr

asm_zx_cy2saddr:

   ; enter : hl = valid character y coordinate
   ;
   ; exit  : hl = screen address of character coordinate row = y, x = 0
   ;
   ; uses  : af, hl

   ld a,l
   and $18
   or $40
   ld h,a
   
   ld a,l
   rrca
   rrca
   rrca
   and $e0
   ld l,a
   
   ret
