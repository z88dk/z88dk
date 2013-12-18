
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
   ; uses  : none

   ld (__seed),hl
   ret
