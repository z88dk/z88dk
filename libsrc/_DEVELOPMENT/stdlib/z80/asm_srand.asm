
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void srand(unsigned int seed)
;
; Set standard random number generator seed.
;
; ===============================================================

INCLUDE "../../crt_vars.inc"

XLIB asm_srand

asm_srand:

   ; enter : hl = seed
   ;
   ; uses  : af

   ld a,h
   or l
   jr nz, seed_ok              ; treat seed == 0 as seed == 1
   
   inc l

seed_ok:

   ld (__seed),hl
   ld (__seed + 2),hl

   ret
