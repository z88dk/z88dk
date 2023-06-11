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
    PUBLIC  asm_fix16_pow2
    EXTERN  asm_fix16_sqrt


asm_fix16_pow2:
pow2:
;Inputs:
;     HL is the 8.8 fixed point number 'x' for 2^x
;Outputs:
;     DEHL is the 24.8 fixed point result. If there was overflow exceeding 2^24, then this value is set to the max.
     ld a,l
     or a
     push hl     ;save H for later, H is the integer part of the power
     ld hl,1
     jr z,integerpow
     scf      ;set the carry flag so that a bit is rotated into a. This will act as our counter.
;wait until we come across the lowest bit. Also note that we
loop0:
     rra
     jr nc,loop0
     ld hl,2*256
powloop:
     push af
     call   asm_fix16_sqrt        ;returns in hl
     pop af
     srl a
     jr z,integerpow
     jr nc,powloop
     add hl,hl
     jp powloop
integerpow:
     pop bc
;Now b is the integer part for 2^x that we need to multiply HL by.
     ld de,0
     ld a,b
     or a
     ret z

loop:
     add hl,hl
     rl e 
     rl d
     jr c,wayoverflow
     djnz loop
     ret
wayoverflow:
     ld hl,-1
     ld d,h
     ld e,l
     ret
