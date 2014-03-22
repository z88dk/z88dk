
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void srand(unsigned int seed)
;
; Set standard random number generator seed.
;
; ===============================================================

XLIB asm_srand

asm_srand:

   ; enter : hl = seed
   ;
   ; uses  : af

   ld (__seed),hl
   ld (__seed + 2),hl

   ret
