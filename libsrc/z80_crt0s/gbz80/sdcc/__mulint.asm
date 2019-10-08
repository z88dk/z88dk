
        SECTION code_l_sdcc

        PUBLIC  __mulint

        GLOBAL  l_mul16

__mulint:
        ld      hl,sp+2

        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        inc     hl
        ld      a,(hl+)
        ld      h,(hl)
        ld      l,a

        ;; Parameters:
        ;;      HL, DE (left, right irrelivent)
        ld      b,h
        ld      c,l
        jp      l_mul16
