
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void srand(unsigned int seed)
;
; Set standard random number generator seed.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_srand

EXTERN __stdlib_seed

asm_srand:

   ; enter : hl = seed
   ;
   ; uses  : af

   ld a,h
   or l
   jr nz, seed_ok
   
   inc l

seed_ok:
IF __CPU_GBZ80__
   ld c,l
   ld b,h 
   ld hl,__stdlib_seed
   ld a,c
   ld (hl+),a
   ld a,b
   ld (hl+),a
   ld a,c
   ld (hl+),a
   ld (hl),b
ELSE
   ld (__stdlib_seed),hl
   ld (__stdlib_seed + 2),hl
ENDIF

   ret
