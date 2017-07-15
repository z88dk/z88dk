
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_aaddrcdown(void *attraddr)
;
; Modify attribute address to move down one character square 
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_aaddrcdown

asm_zx_aaddrcdown:

   ; enter : hl = valid attribute address
   ;
   ; exit  : hl = new attribute address moved down one char square
   ;         carry set if new attribute address is off screen
   ;
   ; uses  : af, hl

   ld a,l
   add a,$20
   ld l,a
   
   ret nc
   inc h

IF __USE_SPECTRUM_128_SECOND_DFILE
   ld a,$da
ELSE
   ld a,$5a
ENDIF

   cp h
   ret
