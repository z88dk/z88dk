
        SECTION code_l_sdcc

        PUBLIC  l_mul16
        ;; Parameters:
        ;;      HL, DE (left, right irrelivent)
        ld      b,h
        ld      c,l

        ;; 16-bit multiplication
        ;;
        ;; Entry conditions
        ;;   BC = multiplicand
        ;;   DE = multiplier
        ;;
        ;; Exit conditions
        ;;   DE = less significant word of product
        ;;
        ;; Register used: AF,BC,DE,HL
l_mul16:
        ld      hl,0
        ld      a,b
        ; ld c,c
        ld      b,16

        ;; Optimise for the case when this side has 8 bits of data or
        ;; less.  This is often the case with support address calls.
        or      a
        jp      NZ,mul_1

        ld      b,8
        ld      a,c
mul_1:
        ;; Taken from z88dk, which originally borrowed from the
        ;; Spectrum rom.
        add     hl,hl
        rl      c
        rla                     ;DLE 27/11/98
        jp      NC,mul_2
        add     hl,de
mul_2:
        dec     b
        jr      NZ,mul_1

        ;; Return in DE
        ld      e,l
        ld      d,h

        ret
