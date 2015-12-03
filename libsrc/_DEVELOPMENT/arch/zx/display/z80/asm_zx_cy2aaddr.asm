
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_cy2aaddr(uchar row)
;
; Character y coordinate to attribute address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_cy2aaddr

asm_zx_cy2aaddr:

   ; enter : hl = valid character y coordinate
   ;
   ; exit  : hl = attribute address at row = y, x = 0
   ;
   ; uses  : af, hl
   
   ld a,l
   rrca
   rrca
   rrca
   ld h,a
   
   and $e0
   ld l,a
   
   ld a,h
   and $03
   or $58
   ld h,a
   
   ret
