;
; Intrinsic sccz80 routine to multiply by a power of 2
;
;
        SECTION code_fp_am9511

        PUBLIC  l_f32_ldexp

; Entry: dehl = float, a = adjustment for exponent
;        stack = ret
;
; Exit:  dehl = adjusted float

IFDEF __CPU_8085__

.l_f32_ldexp
        push af                     ; save power

        rl de                       ; get the sign and exponent

        inc d
        dec d
        jp Z,zero_legal

        ld a,e
        rra                         ; save sign in e[7]
        ld e,a

        pop af                      ; restore power
        add d
        ld d,a

        ld a,e
        rla                         ; restore sign to C
        ld e,a

        ld a,d
        rra                         ; sign and new exponent
        ld d,a
        ld a,e                      ; new exponent and mantissa
        rra
        ld e,a

        ret

.zero_legal
        ld e,d                      ; use 0
        ld hl,de

        ld a,d
        rra                         ; return sign and exponent
        ld d,a

        pop af                      ; balance stack
        ret                         ; return IEEE signed ZERO in DEHL

ELSE

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
        ld hl,de

        rr d                        ; restore the sign and exponent
        ret                         ; return IEEE signed ZERO in DEHL

ENDIF
