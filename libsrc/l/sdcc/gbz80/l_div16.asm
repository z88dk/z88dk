
        SECTION code_l_sdcc

        PUBLIC  l_div8
        PUBLIC  l_mod8
        PUBLIC  l_div8_signexte
        PUBLIC  l_div16
        PUBLIC  l_mod16

        GLOBAL  l_divu16

l_div8:
l_mod8:
        ld      a,c             ; Sign extend
        rlca
        sbc     a
        ld      b,a
l_div8_signexte:
        ld      a,e             ; Sign extend
        rlca
        sbc     a
        ld      d,a

        ; Fall through to .div16

        ;; 16-bit division
        ;;
        ;; Entry conditions
        ;;   BC = dividend
        ;;   DE = divisor
        ;;
        ;; Exit conditions
        ;;   BC = quotient
        ;;   DE = remainder
        ;;   If divisor is non-zero, carry=0
        ;;   If divisor is 0, carry=1 and both quotient and remainder are 0
        ;;
        ;; Register used: AF,BC,DE,HL
l_div16:
l_mod16:
        ;; Determine sign of quotient by xor-ing high bytes of dividend
        ;;  and divisor. Quotient is positive if signs are the same, negative
        ;;  if signs are different
        ;; Remainder has same sign as dividend
        ld      a,b             ; Get high byte of dividend
        push    af              ; Save as sign of remainder
        xor     d               ; Xor with high byte of divisor
        push    af              ; Save sign of quotient

        ;; Take absolute value of divisor
        bit     7,d
        jr      Z,chkde        ; Jump if divisor is positive
        sub     a               ; Substract divisor from 0
        sub     e
        ld      e,a
        sbc     a               ; Propagate borrow (A=0xFF if borrow)
        sub     d
        ld      d,a
        ;; Take absolute value of dividend
chkde:
        bit     7,b
        jr      Z,dodiv        ; Jump if dividend is positive
        sub     a               ; Substract dividend from 0
        sub     c
        ld      c,a
        sbc     a               ; Propagate borrow (A=0xFF if borrow)
        sub     b
        ld      b,a
        ;; Divide absolute values
dodiv:
        call    l_divu16
        jr      C,exit         ; Exit if divide by zero
        ;; Negate quotient if it is negative
        pop     af              ; recover sign of quotient
        and     0x80
        jr      Z,dorem        ; Jump if quotient is positive
        sub     a               ; Substract quotient from 0
        sub     c
        ld      c,a
        sbc     a               ; Propagate borrow (A=0xFF if borrow)
        sub     b
        ld      b,a
dorem:
        ;; Negate remainder if it is negative
        pop     af              ; recover sign of remainder
        and     0x80
        ret     Z               ; Return if remainder is positive
        sub     a               ; Substract remainder from 0
        sub     e
        ld      e,a
        sbc     a               ; Propagate remainder (A=0xFF if borrow)
        sub     d
        ld      d,a
        ret
exit:
        pop     af
        pop     af
        ret
