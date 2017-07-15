
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_pxy2aaddr(uchar x, uchar y)
;
; Attribute address corresponding to pixel coordinate x, y.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_pxy2aaddr

asm_zx_pxy2aaddr:

   ; enter : l = x coordinate
   ;         h = valid y coordinate
   ;
   ; exit  : hl = attribute address corresponding to pixel
   ;
   ; uses  : af, hl

   srl l
   srl l
   srl l

   ld a,h
   rlca
   rlca
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
