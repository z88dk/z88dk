
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_pxy2saddr(uchar x, uchar y)
;
; Screen address of byte containing pixel at coordinate x, y.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_pxy2saddr
PUBLIC asm0_zx_pxy2saddr

asm_zx_pxy2saddr:

   ; enter :  l = x coordinate
   ;          h = valid y coordinate
   ;
   ; exit  : hl = screen address of byte containing pixel
   ;          e = x coordinate
   ;          d = y coordinate
   ;
   ; uses  : af, de, hl
   
   ld a,h
   and $07

IF __USE_SPECTRUM_128_SECOND_DFILE
   or $c0
ELSE
   or $40
ENDIF

asm0_zx_pxy2saddr:

   ld d,a
   
   ld a,h
   rra
   rra
   rra
   and $18
   or d
   ld d,a
   
   ld a,l
   rra
   rra
   rra
   and $1f
   ld e,a
   
   ld a,h
   add a,a
   add a,a
   and $e0

   or e
   ld e,a

   ex de,hl
   ret
