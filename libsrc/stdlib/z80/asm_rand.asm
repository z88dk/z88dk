
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

IF __CPU_GBZ80__
   ld hl,__stdlib_seed + 3
   ld a,(hl-)
   ld d,a
   ld a,(hl-)
   ld e,a
   ld a,(hl-)
   ld l,(hl)
   ld h,a
ELSE
   ld hl,(__stdlib_seed)
  IF __CPU_INTEL__
   ex de,hl
   ld hl,(__stdlib_seed + 2)
   ex de,hl
  ELSE
   ld de,(__stdlib_seed + 2)
  ENDIF
ENDIF

   ; generate next prng in sequence
   
   call asm_random_uniform_xor_32  ; marsaglia xor generator

   ; store new seed
IF __CPU_GBZ80__
   ld c,l
   ld b,h
   ld hl,__stdlib_seed
   ld a,c
   ld (hl+),a
   ld a,b
   ld (hl+),a
   ld a,e
   ld (hl+),a
   ld a,d
   ld (hl+),a
   ld l,c
   ld h,b
ELSE
   ld (__stdlib_seed),hl
  IF __CPU_INTEL__
   ex de,hl
   ld (__stdlib_seed + 2),hl
   ex de,hl

  ELSE
   ld (__stdlib_seed + 2),de
  ENDIF
ENDIF
   
   ; create a 15-bit result that includes 0
   
   ld a,d
   xor l
   ld l,a
   
   ld a,e
   xor h
   and $7f
   ld h,a
   
   ret
