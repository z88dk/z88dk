

        SECTION code_fp_dai32

        PUBLIC  ___dai32_setup_arith
        EXTERN  ___dai32_tempval
        EXTERN  ___dai32_fpac


; Put the two arguments into the required places
;
; This is for arithmetic routines, where we need to use
; double precision values (so pad them out)
;
; Entry: dehl = right hand operand
; Stack: defw return address
;        defw callee return address
;        defw left hand LSW
;        defw left hand MSW
___dai32_setup_arith:
	; The right value needs to go into temporary variable
        ld      a, h
        ld      h, l
        ld      l, a
        ld      (___dai32_tempval+2), hl
        ex      de, hl
        ld      a, h
        ld      h, l
        ld      l, a
        ld      (___dai32_tempval+0), hl

        pop     de                      ;return address
        pop     bc                      ;Caller return address
    ; Left hand side needs to go into the fpac
        pop     hl                      ;Left LSW
        ld      a, h
        ld      h, l
        ld      l, a
        ld      (___dai32_fpac+2), hl
        pop     hl                      ;Left MSW
        ld      a, h
        ld      h, l
        ld      l, a
        ld      (___dai32_fpac+0), hl
        ld      hl, ___dai32_tempval
        push    bc
        push    de
        ret
