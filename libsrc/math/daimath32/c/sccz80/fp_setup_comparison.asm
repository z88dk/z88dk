

        SECTION code_fp_dai32

        PUBLIC  ___dai32_setup_comparison
        EXTERN  ___dai32_fpac
        EXTERN  ___dai32_tempval
        EXTERN  ___dai32_fpcomp



; Put the two arguments into the required places
;
; This is for comparison routines, where we need to use
; double precision values (so pad them out)
;
; Entry: dehl = right hand operand
; Stack: defw return address
;        defw callee return address
;        defw left hand LSW
;        defw left hand MSW
___dai32_setup_comparison:
    ; The right value needs to go into FPREG
        ld      a, h
        ld      h, l
        ld      l, a
        ld      (___dai32_tempval+2), hl
        ex      de, hl
        ld      a, h
        ld      h, l
        ld      l, a
        ld      (___dai32_tempval+0), hl
        pop     bc                      ;Return address
        pop     de                      ;Caller return address
        pop     hl                      ;Left LSW
        ld      a, h
        ld      h, l
        ld      l, a
        ld      (___dai32_fpac+2), hl
        pop     hl
        ld      a, h
        ld      h, l
        ld      l, a
        ld      (___dai32_fpac+0), hl
        push    de
        push    bc
        ld      hl, ___dai32_tempval
        call    ___dai32_fpcomp
        ret
