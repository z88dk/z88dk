
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_py2saddr(uchar y)
;
; Screen address of byte containing pixel at coordinate x = 0, y.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC old_zx_py2saddr
PUBLIC old0_zx_py2saddr

old_zx_py2saddr:

   ; enter :  l = valid pixel y coordinate
   ;
   ; exit  : hl = screen address of byte containing pixel at x = 0, y.
   ;         carry reset
   ;
   ; uses  : af, hl

   ld a,l
   and $07

IF __USE_SPECTRUM_128_SECOND_DFILE
   or $c0
ELSE
   or $40
ENDIF

old0_zx_py2saddr:

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
