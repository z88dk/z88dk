
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
   
   or a

asm0_zx_pxy2saddr:

   ld a,h
   rra
   scf
   rra
IF __USE_SPECTRUM_128_SECOND_DFILE
   ; target $c0 or $e0 (CF 0/1 at asm0_zx_pxy2saddr)
   scf
ELSE
   ; target $40 or $60 (CF 0/1 at asm0_zx_pxy2saddr)
   or a
ENDIF
   rra
   ld e,a

   xor h
   and %11111000
   xor h
   ld d,a

   ld a,l
   xor e
   and %11111000
   xor e

   rrca
   rrca
   rrca
   ld e,a

   ex de,hl
   ret
