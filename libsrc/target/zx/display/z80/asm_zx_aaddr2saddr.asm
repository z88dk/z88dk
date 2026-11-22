
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_aaddr2saddr(void *attraddr)
;
; Attribute address to screen address. 
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_aaddr2saddr

asm_zx_aaddr2saddr:

   ; enter : hl = valid attribute address
   ;
   ; exit  : hl = screen address corresponding to the topmost
   ;              pixel byte in the attribute square
   ;
   ; uses  : af, hl
   
   ld a,h
   
   rlca
   rlca
   rlca

IF __USE_SPECTRUM_128_SECOND_DFILE
   xor $06
ELSE
   xor $82
ENDIF

   ld h,a
   ret
