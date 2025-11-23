
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_aaddrcright(void *attraddr)
;
; Modify attribute address to move right one character square.
; Movement wraps from column 31 to column 0 of next row.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_aaddrcright

asm_zx_aaddrcright:

   ; enter : hl = valid attribute address
   ;
   ; exit  : hl = new attribute address moved right one char square
   ;         carry set if new attribute address is off screen
   ;
   ; uses  : af, hl
   
   inc hl

IF __USE_SPECTRUM_128_SECOND_DFILE
   ld a,$da
ELSE
   ld a,$5a
ENDIF

   cp h   
   ret
