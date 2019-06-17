;
; Intrinsic sccz80 routine to multiply by a power of 2
;
;
        SECTION code_fp_math32

        PUBLIC  l_f32_ldexp

; Entry: a = adjustment for exponent
;       Stack: float, ret
; Exit: dehl = adjusted float

l_f32_ldexp:
        sla e                       ; get the exponent
        rl d
        rr e                        ; save the sign in e[7]

        add d
        ld d,a                      ; exponent returned
        rl e                        ; get sign back
        rr d
        rr e

        and a                       ; check for zero exponent
        ret NZ                      ; return IEEE in DEHL

        ld a,d
        ld e,0
        ld h,e
        ld l,e
        scf
        ret                         ; return IEEE underflow ZERO in DEHL
