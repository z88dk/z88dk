
; ===============================================================
; Dec 2013
; ===============================================================
;
; Generates the next 32-bit prng in the sequence, given seed.
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

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_random_uniform_xor_32

asm_random_uniform_xor_32:

   ; XorShift RNG using triple (8,9,23)
   ;
   ; enter: dehl = seed (0 is invalid input)
   ; exit : dehl = next number in sequence [1..ULONG_MAX

   ;
   ; uses : af, de, hl

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

   ret
