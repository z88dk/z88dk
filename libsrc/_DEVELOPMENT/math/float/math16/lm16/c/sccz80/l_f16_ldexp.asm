;
; Intrinsic sccz80 routine to multiply by a power of 2
;
;
SECTION code_fp_math16

PUBLIC  l_f16_ldexp

EXTERN asm_f16_zero

EXTERN asm_f24_f16
EXTERN asm_f16_f24

; Entry: hl = float, a = adjustment for exponent
;        stack = ret
;
; Exit:  dehl = adjusted float

.l_f16_ldexp
    ld b,a                      ; save exponent adjustment
    call asm_f24_f16            ; convert to expanded format

    ld a,d                      ; get the exponent
    and a
    jp Z,asm_f16_zero           ; return IEEE signed zero
    
    add a,b                     ; pw2
    ld d,a                      ; exponent returned
    jp asm_f16_f24              ; return IEEE HL

