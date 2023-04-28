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
    PUBLIC  l_fix88_sin
    PUBLIC  l_fix88_cos

    EXTERN  l_mulu_32_16x16

l_fix88_cos:
    ld      de,0x0192           ;halfpi
    add     hl,de

; Entry: h.l = number
; Exit:  h.l = result
l_fix88_sin:
    ex      de,hl

sine_88:
   ;Inputs: de
       push de
       sra d 
       rr e
       ld b,d 
       ld c,e
       call BC_Times_DE
       push hl     ;x^2/4
       sra h 
       rr l
       ex de,hl
       ld b,d
       ld c,e
       call BC_Times_DE
       sra h 
       rr l
       inc h
       ex (sp),hl    ;x^4/128+1 is on stack, HL=x^2/4
       xor a
       ld d,a
       ld b,h
       ld c,l
       add hl,hl 
       rla
       add hl,hl 
       rla
       add hl,bc
       adc a,d
       ld b,h
       ld c,l
       add hl,hl 
       rla
       add hl,hl
       rla
       add hl,hl 
       rla
       add hl,hl 
       rla
       add hl,bc
       adc a,d
       ld e,l
       ld l,h
       ld h,a
       rl e
       adc hl,hl
       rl e
       jr nc,skip_inchl
       inc hl
skip_inchl:
       pop de
       ex de,hl
       or a
       sbc hl,de
       ex de,hl
       pop bc
       call BC_Times_DE
       ld       h,l         ;And switch them back for our ABI
       ld       l,a
       ret


;  BC*DE->BHLA
BC_Times_DE:
    ld  bc,hl
    call    l_mulu_32_16x16     ;Gives dehl
                                ;bhla
    ld      a,l
    ld      l,h
    ld      h,e
    ld      b,d
    ret
