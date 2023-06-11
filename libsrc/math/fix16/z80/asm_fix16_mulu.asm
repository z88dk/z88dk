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
    PUBLIC  asm_fix16_mulu

    EXTERN  l_mulu_32_16x16

asm_fix16_mulu:

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
  ret
