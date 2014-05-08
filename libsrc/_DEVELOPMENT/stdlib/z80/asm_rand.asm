
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int rand(void)
;
; Generates a random number in the range 0 .. RAND_MAX = 32767
; 
; This random number generator is a 32-bit XorShift RNG as
; described by Marsaglia:
;
; http://www.jstatsoft.org/v08/i14/paper
;
; The triple used is (L,R,L) = (8,9,23) which is very quickly
; implemented on the z80.
;
; ===============================================================

PUBLIC asm_rand

EXTERN __seed

asm_rand:

   ; XorShift RNG using triple (8,9,23)
   ;
   ; exit : hl = random number in [0, 32767]
   ;
   ; uses : af, de, hl

   ld hl,(__seed)
   ld de,(__seed + 2)

   ; dehl ^= dehl << 8

   ld a,d
   xor e
   ld d,a

   ld a,e
   xor h
   ld e,a

   ld a,h
   xor l
   ld h,a

   ; dehl ^= dehl >> 9

   ld a,e
   rra
   ld a,h
   rra
   xor l
   ld l,a

   ld a,d
   rra
   ld a,e
   rra
   xor h
   ld h,a

   ld a,d
   srl a
   xor e
   ld e,a

   ; dehl ^= dehl << 23

   ld a,h
   rra
   ld a,l
   rra
   xor d
   ld d,a

   ld a,l
   rra
   ld a,0
   rra
   xor e
   ld e,a

   ; store new seed

   ld (__seed),hl
   ld (__seed + 2),de
   
   ; create a 15-bit result that includes 0
   
   ld a,d
   xor l
   ld l,a
   
   ld a,e
   xor h
   and $7f
   ld h,a
   
   ret
