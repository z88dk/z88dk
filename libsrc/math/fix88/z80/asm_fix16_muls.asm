;
; Z80 fixed Q8.8 maths routines
;
; These routines have been adapted from two sources:
;
; https://learn.cemetech.net/index.php/Z80:Advanced_Math
; 
; and
; 
; https://github.com/Zeda/Z80-Optimized-Routines/tree/master/math
;
;

    SECTION code_math
    PUBLIC  asm_fix16_muls

    EXTERN  l_mulu_32_16x16

asm_fix16_muls:

mulfixed_88:
;Multiplies H.L by D.E, stores the result in H.L
; First, find out if the output is positive or negative
  ld a,h
  xor d
  push af   ;sign bit is the result sign bit

; Now make sure the inputs are positive
  xor d     ;A now has the value of H, since I XORed it with D twice (cancelling)
  jp p,skip_negate   ;if Positive, don't negate
  xor a
  sub l
  ld l,a
  sbc a,a
  sub h
  ld h,a
skip_negate:
  bit 7,d
  jr z,skip_negate2
  xor a
  sub e
  ld e,a
  sbc a,a
  sub d
  ld d,a
skip_negate2:

    call    l_mulu_32_16x16


;Need to round, so get the top bit of L
  sla l

;Get the middle two bytes, EH, and put them in HL
  ld l,h
  ld h,e

  ld a,d
  ld de,0
  adc hl,de

;check for overflow!
;We should check for overflow. If A>0, we will set HL to 0x7FFF
  adc a,e
  jr c,overflow
  jr z,skip_overflow
overflow:
  ld hl,$7FFF
skip_overflow:

; Now we need to restore the sign
  pop af
  ret p    ;don't need to do anything, result is already positive
  xor a
  sub l
  ld l,a
  sbc a,a
  sub h
  ld h,a
  ret
