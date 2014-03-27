
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

XREF __seed

asm_srand:

   ; enter : hl = seed
   ;
   ; uses  : af

   ld a,h
   or l
   jr nz, seed_ok
   
   inc hl

seed_ok:

   ld (__seed),hl
   ld (__seed + 2),hl

   ret
