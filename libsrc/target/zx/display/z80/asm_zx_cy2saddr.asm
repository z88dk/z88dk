
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_cy2saddr(uchar row)
;
; Character y coordinate to screen address.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_cy2saddr

asm_zx_cy2saddr:

   ; enter :  l = valid character y coordinate
   ;
   ; exit  : hl = screen address of character coordinate row = y, x = 0
   ;
   ; uses  : af, hl

   ld a,l
   and $18

IF __USE_SPECTRUM_128_SECOND_DFILE
   or $c0
ELSE
   or $40
ENDIF

   ld h,a
   
   ld a,l
   rrca
   rrca
   rrca
   and $e0
   ld l,a
   
   ret
