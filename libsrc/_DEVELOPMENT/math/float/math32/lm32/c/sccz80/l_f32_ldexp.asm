;
; Intrinsic sccz80 routine to multiply by a power of 2
;
;
        SECTION code_fp_math32

        PUBLIC  l_f32_ldexp

; Entry: dehl = float, a = adjustment for exponent
;        stack = ret
;
; Exit:  dehl = adjusted float

.l_f32_ldexp
        sla e                       ; get the exponent
        rl d
        jr Z,zero_legal             ; return IEEE zero
        rr e                        ; save the sign in e[7]

        add d
        ld d,a                      ; exponent returned

        rl e                        ; restore sign to C
        rr d
        rr e

        and a                       ; check for zero exponent result
        ret NZ                      ; return IEEE in DEHL

        ld e,a
        ld h,a
        ld l,a
        scf
        ret                         ; return IEEE underflow ZERO in DEHL

.zero_legal
        ld e,d                      ; use 0
        ld h,d
        ld l,d
        rr d                        ; restore the sign
        ret                         ; return IEEE signed ZERO in DEHL
