
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_py2aaddr(uchar y)
;
; Attribute address corresponding to pixel coordinate x = 0, y.
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_py2aaddr

asm_zx_py2aaddr:

   ; enter :  l = valid pixel y coordinate
   ;
   ; exit  : hl = attribute address containing pixel at x = 0, y.
   ;
   ; uses  : af, hl
   
   ld a,l
   rlca
   rlca
   ld h,a
   
   and $e0
   ld l,a
   
   ld a,h
   and $03
   or $58
   ld h,a
   
   ret
