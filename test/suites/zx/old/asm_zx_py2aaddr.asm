
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_py2aaddr(uchar y)
;
; Attribute address corresponding to pixel coordinate x = 0, y.
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC old_zx_py2aaddr

old_zx_py2aaddr:

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

IF __USE_SPECTRUM_128_SECOND_DFILE
   or $d8
ELSE
   or $58
ENDIF

   ld h,a   
   ret
