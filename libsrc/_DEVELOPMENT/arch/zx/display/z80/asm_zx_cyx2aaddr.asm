
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_cyx2aaddr(uchar row, uchar col)
;
; Attribute address of character square at row, col.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_cyx2aaddr

asm_zx_cyx2aaddr:

   ; enter : h = valid character y coordinate
   ;         l = valid character x coordinate
   ;
   ; exit  : hl = attribute address corresponding to character
   ;
   ; uses  : af, hl

   ld a,h
   rrca
   rrca
   rrca
   ld h,a
   
   and $e0
   or l
   ld l,a
   
   ld a,h
   and $03
   or $58
   ld h,a
   
   ret
