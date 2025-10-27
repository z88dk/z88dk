
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_cxy2saddr(uchar x, uchar y)
;
; Screen address of top pixel row of character square at x,y.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_cxy2saddr

asm_zx_cxy2saddr:

   ; enter : h = valid character y coordinate
   ;         l = valid character x coordinate
   ;
   ; exit  : hl = screen address corresponding to the top
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
   or $c0
ELSE
   or $40
ENDIF

   ld h,a   
   ret
