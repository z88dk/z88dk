
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

IF __USE_SPECTRUM_128_SECOND_DFILE
   ld h,$d8/4
ELSE
   ld h,$58/4
ENDIF

   rla
   rl h
   rla
   rl h

   and $e0
   or l
   ld l,a
   ret
