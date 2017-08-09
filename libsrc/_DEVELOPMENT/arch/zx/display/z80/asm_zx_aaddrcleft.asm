
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_aaddrcleft(void *attraddr)
;
; Modify attribute address to move left one character square.
; Movement wraps from column 0 to column 31 of previous row.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_aaddrcleft

asm_zx_aaddrcleft:

   ; enter : hl = valid attribute address
   ;
   ; exit  : hl = new attribute address moved left one char square
   ;         carry set if new attribute address is off screen
   ;
   ; uses  : af, hl
   
   dec hl

   ld a,h

IF __USE_SPECTRUM_128_SECOND_DFILE
   cp $d8
ELSE
   cp $58
ENDIF

   ret
