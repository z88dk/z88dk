
        SECTION code_clib
        PUBLIC  __tms9918_text_xypos

        EXTERN  __console_w


; Entry: b = row, c = column
__tms9918_text_xypos:
        ld      de,(__console_w)
        ld      d,0
        ld      hl,0
        and     a
        sbc     hl,de
        inc     b
xypos_1:
        add     hl,de
        djnz    xypos_1
        add     hl,bc
        ret
