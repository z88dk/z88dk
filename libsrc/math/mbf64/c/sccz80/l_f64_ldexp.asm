
;
; Intrinsic sccz80 routine to multiply by a power of 2
;
;
        SECTION code_fp_mbf64

        PUBLIC  l_f64_ldexp
        EXTERN  ___mbf64_FA

; Entry: a = adjustment for exponent
;       Stack: float, ret
; Exit: dehl = adjusted float

l_f64_ldexp:
        ld      hl,2
        add     hl,sp
        ld      de,___mbf64_FA
        ld      bc,8
        ldir        
        pop     hl        ;return
        pop     bc      ;dump float
        pop     bc
        pop     bc
        pop     bc
        push    hl
        ld      hl,___mbf64_FA+7
        add     (hl)
        ld      (hl),a
        ret

