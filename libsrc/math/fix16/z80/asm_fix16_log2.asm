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
    PUBLIC  asm_fix16_log2


asm_fix16_log2:

Log_2_88_size:
;Inputs:
;     HL is an unsigned 8.8 fixed point number.
;Outputs:
;     HL is the signed 8.8 fixed point value of log base 2 of the input.
;Example:
;     pass HL = 3.0, returns 1.58203125 (actual is ~1.584962501...)
;averages about 39 t-states slower than original
;62 bytes
     ex de,hl
     ld hl,0
     ld a,d
     ld c,8
     or a
     jr z,DE_lessthan_1
shift_loop:
     srl d
     jr z,logloop-1
     inc l
     rr e
     jr shift_loop
DE_lessthan_1:
     ld a,e
     dec hl
     or a
     ret z
     inc l
scale_loop:
     dec l
     add a,a
     jr nc,scale_loop
     ld e,a

     inc d
logloop:
     add hl,hl
     push hl
     ld h,d
     ld l,e
     ld a,e
     ld b,8

loop_add:
     add hl,hl
     rla
     jr nc,loop_add_cont
       add hl,de
       adc a,0
loop_add_cont:
     djnz loop_add

     ld e,h
     ld d,a
     pop hl
     rr a         ;this is NOT supposed to be rra, we need the z flag affected
     jr z,loop_cont
       srl d
       rr e
       inc l
loop_cont:
     dec c
     jr nz,logloop
     ret
