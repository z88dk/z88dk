
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_cxy2aaddr(uchar x, uchar y)
;
; Attribute address of character square at x,y.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_cxy2aaddr

asm_zx_cxy2aaddr:

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

IF __USE_SPECTRUM_128_SECOND_DFILE
   or $d8
ELSE
   or $58
ENDIF

   ld h,a
   ret
