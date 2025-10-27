
        SECTION code_l_sdcc

        PUBLIC  __muluchar

        GLOBAL  l_mul16

__muluchar:
        ld      hl,sp+2

        ld      e,(hl)

        inc     hl
        ld      c,(hl)

        ;; Clear the top
        xor     a
        ld      d,a
        ld      b,a

        jp      l_mul16
