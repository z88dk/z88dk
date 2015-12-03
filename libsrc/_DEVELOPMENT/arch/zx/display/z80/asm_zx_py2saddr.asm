
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_py2saddr(uchar y)
;
; Screen address of byte containing pixel at coordinate x = 0, y.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_py2saddr

asm_zx_py2saddr:

   ; enter :  l = valid pixel y coordinate
   ;
   ; exit  : hl = screen address of byte containing pixel at x = 0, y.
   ;
   ; uses  : af, hl

   ld a,l
   and $07
   or $40
   ld h,a
   
   ld a,l
   rra
   rra
   rra
   and $18
   or h
   ld h,a
   
   ld a,l
   add a,a
   add a,a
   and $e0
   ld l,a
   
   ret
