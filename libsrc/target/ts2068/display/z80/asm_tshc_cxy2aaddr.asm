; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_cxy2aaddr(uchar x, uchar y)
;
; Attribute address of top pixel row of character square at x,y.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_cxy2aaddr

asm_tshc_cxy2aaddr:

   ; enter : h = valid character y coordinate
   ;         l = valid character x coordinate
   ;
   ; exit  : hl = attribute address corresponding to the top
   ;              pixel row of the character square
   ;
   ; uses  : af, hl

   ld a,h
   rrca
   rrca
   rrca
   and $e0
   or l
   ld l,a
   
   ld a,h
   and $18

IF __USE_SPECTRUM_128_SECOND_DFILE
   or $e0
ELSE
   or $60
ENDIF

   ld h,a   
   ret
