
        SECTION code_fp_math32
        PUBLIC  l_f32_swap

; Entry: dehl = right hand operand
; Stack: defw return address
;        defw left hand LSW
;        defw left hand MSW
.l_f32_swap
        pop     bc      ; Return
        push    de
        push    hl      ; SP: right(4), left(4)
        push    bc      ; SP: ret, right, left
        ld      hl,2
        add     hl,sp   ; &right
        ex      de,hl
        ld      hl,6
        add     hl,sp   ; &left
        ld      b,4
.swloop
        ld      a,(de)
        ld      c,a     ; right byte (ld (de),r is A-only)
        ld      a,(hl)  ; left byte
        ld      (de),a  ; left → right
        inc     de
        ld      (hl),c  ; right → left
        inc     hl
        djnz    swloop
        pop     bc      ; BC = ret
        pop     hl      ; left LSW
        pop     de      ; left MSW → DEHL = left
        push    bc      ; ret
        ret
