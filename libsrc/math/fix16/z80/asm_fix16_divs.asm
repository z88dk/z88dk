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
    PUBLIC  asm_fix16_divs

    EXTERN  l_long_div

;Inputs:
;     hl,de are 8.8 Fixed Point numbers (hl/de)
;Outputs:
;     HL is the 8.8 Fixed Point result (rounded to the least significant bit)
asm_fix16_divs:
    ld      bc,hl

BC_Div_DE_88:
;Inputs:
;     DE,BC are 8.8 Fixed Point numbers
;Outputs:
;     HL is the 8.8 Fixed Point result (rounded to the least significant bit)
;if DE is 0 : 122cc or 136cc if BC is negative
;if |BC|>=128*|DE| : 152cc or 166cc if BC is negative
;Otherwise:
;min: 1164cc
;max: 1377cc
;avg: 1258.5cc
; First, find out if the output is positive or negative
    ld a,b
    xor d
    push af   ;sign bit is the result sign bit

; Now make sure the inputs are positive
    xor d     ;A now has the value of B, since I XORed it with D twice (cancelling)
    jp p,skip_negate  ;if Positive, don't negate
    xor a
    sub c
    ld c,a
    sbc a,a
    sub b
    ld b,a
skip_negate:

;now make DE negative to optimize the remainder comparison
    ld a,d
    or d
    jp m,skip_negate2
    xor a
    sub e
    ld e,a
    sbc a,a
    sub d
    ld d,a
skip_negate2:

;if DE is 0, we can call it an overflow
;A is the current value of D
  or e
  jr z,div_fixed88_overflow

;The accumulator gets set to B if no overflow.
;We can use H=0 to save a few cc in the meantime
    ld h,0

;if B+DE>=0, then we'll have overflow
    ld a,b
    add a,e
    ld a,d
    adc a,h
    jr c,div_fixed88_overflow

;Now we can load the accumulator/remainder with B
;H is already 0
    ld l,b

    ld a,c
    call div_fixed88_sub
    ld c,a

    ld a,b      ;A is now 0
    call div_fixed88_sub

; if 2HL+DE>=0, increment result to round.
    add hl,hl
    add hl,de
    ld h,c
    ld l,a
    jr nc,$+3
    inc hl

;Now check if H is overflowed
    bit 7,h
    jr nz,div_fixed88_overflow


    pop af
    ret p
    xor a
    sub l
    ld l,a
    sbc a,a
    sub h
    ld h,a
    ret

div_fixed88_overflow:
    ld hl,$7FFF
    pop af
    ret p
    inc hl
    inc l
    ret

div_fixed88_sub:
;min: 456cc
;max: 536cc
;avg: 496cc
    ld b,8
fix_loop:
    rla
    adc hl,hl
    add hl,de
    jr c,$+4
    sbc hl,de
    djnz fix_loop
    adc a,a
    ret
