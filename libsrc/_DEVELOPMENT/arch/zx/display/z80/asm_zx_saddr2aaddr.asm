
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_saddr2aaddr(void *saddr)
;
; Attribute address corresponding to screen address.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_saddr2aaddr

asm_zx_saddr2aaddr:

   ld a,h
   rra
   rra
   rra
   and $03

IF __USE_SPECTRUM_128_SECOND_DFILE
   or $d8
ELSE
   or $58
ENDIF

   ld h,a   
   ret
