
SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_div_u

; HL = DE / HL, DE = DE % HL
l_div_u:
    ld      a,h             ; use the shorter path for an 8-bit divisor
    or      a
    jp      nz,div_16
    ld      a,l
    or      a
    jp      z,div_16

    ld      bc,hl           ; preserve the divisor in BC for callers
    push    bc
    ex      de,hl           ; HL = dividend, E = divisor
    xor     a               ; clear the remainder
    ld      b,16
div_8_loop:
    add     hl,hl           ; shift the next dividend bit into carry
    rla                     ; shift it into the remainder
    jp      c,div_8_sub     ; overflow means remainder >= divisor
    cp      e
    jp      c,div_8_next
div_8_sub:
    sub     e
    inc     l               ; set the next quotient bit
div_8_next:
    dec     b
    jp      nz,div_8_loop
    ld      e,a
    ld      d,0
    or      a               ; match l_div_u's clear-carry return
    pop     bc
    ret

div_16:
    LD      bc,hl           ; store divisor to bc
    LD      hl,0            ; clear remainder
    XOR     a               ; clear carry
    LD      a,17            ; load loop counter
    PUSH    af
ccduv1:
    LD      a,e             ; left shift dividend into carry
    RLA
    LD      e,a
    LD      a,d
    RLA
    LD      d,a
    JP      C,ccduv2        ; we have to keep carry -> calling else branch

    POP     af              ; decrement loop counter
    DEC     a
    JP      Z,ccduv5

    PUSH    af
    XOR     a               ; clear carry
    JP      ccduv3

ccduv2:
    POP     af              ; decrement loop counter
    DEC     a
    JP      Z,ccduv5

    PUSH    af
    SCF                     ; set carry
ccduv3:
    LD      a,l             ; left shift carry into remainder
    RLA
    LD      l,a
    LD      a,h
    RLA
    LD      h,a
    LD      a,l             ; substract divisor from remainder
    sub     c
    LD      l,a
    LD      a,h
    SBC     b
    LD      h,a
    JP      NC,ccduv4       ; if result negative, add back divisor, clear carry

    LD      a,l             ; add back divisor
    ADD     a,c
    LD      l,a
    LD      a,h
    ADC     a,b
    LD      h,a
    XOR     a               ; clear carry
    JP      ccduv1

ccduv4:
    SCF                     ; set carry
    JP      ccduv1
        
ccduv5:
    EX      de,hl
    ret
