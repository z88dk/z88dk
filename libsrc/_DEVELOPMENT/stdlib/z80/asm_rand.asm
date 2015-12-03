
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int rand(void)
;
; Generates a random number in the range 0 .. RAND_MAX = 32767
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_rand

EXTERN __stdlib_seed, asm_random_uniform_xor_32

asm_rand:

   ; Generate random number in [0, 32767

   ;
   ; Note:  The random sequence generator is kept separate
   ; from the standard C subroutine so that other areas of
   ; the clib can generate random numbers without affecting
   ; the user program's seed.
   ;
   ; exit : hl = random number in [0, 32767

   ;
   ; uses : af, bc, de, hl

   ; get current seed
   
   ld hl,(__stdlib_seed)
   ld de,(__stdlib_seed + 2)

   ; generate next prng in sequence
   
   call asm_random_uniform_xor_32  ; marsaglia xor generator

   ; store new seed

   ld (__stdlib_seed),hl
   ld (__stdlib_seed + 2),de
   
   ; create a 15-bit result that includes 0
   
   ld a,d
   xor l
   ld l,a
   
   ld a,e
   xor h
   and $7f
   ld h,a
   
   ret
