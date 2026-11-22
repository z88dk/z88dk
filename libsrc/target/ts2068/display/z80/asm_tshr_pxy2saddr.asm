; ===============================================================
; May 2017
; ===============================================================
;
; void *tshr_pxy2saddr(uint x, uchar y)
;
; Screen address of byte containing pixel at coordinate x, y.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_pxy2saddr
PUBLIC asm0_tshr_pxy2saddr

asm_tshr_pxy2saddr:

   ; enter :  hl = valid x coordinate
   ;           c = valid y coordinate
   ;
   ; exit  : hl = screen address of byte containing pixel
   ;         de = x coordinate
   ;          c = y coordinate
   ;
   ; uses  : af, de, hl
   
   ld a,c
   and $07

IF __USE_SPECTRUM_128_SECOND_DFILE
   or $c0
ELSE
   or $40
ENDIF

asm0_tshr_pxy2saddr:

   ld d,a
   
   ld a,c
   rra
   rra
   rra
   and $18
   or d
   ld d,a
   
   ld a,h
   rra
   ld a,l
   rra
   rra
   rra
   rra
   
   jr nc, dfile0
   set 5,d

dfile0:

   and $1f
   ld e,a
   
   ld a,c
   add a,a
   add a,a
   and $e0
   
   or e
   ld e,a
   
   ex de,hl
   ret
