SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_div_u

; HL = DE / HL, DE = DE % HL
;
; VM1 has the carry-aware 16-bit operations used by the compact Z80
; divider, but it does not have the 8085 RDEL instruction.  DE holds the
; dividend and, as it shifts out, the quotient; HL is the partial remainder
; and BC the divisor.  Carry carries the previous quotient bit into DE.
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
    xor     a               ; A = remainder
    ld      b,16
div_8_loop:
    add     hl,hl           ; shift the next dividend bit into carry
    rla                     ; ... and into the remainder
    jp      c,div_8_sub     ; overflow means remainder >= divisor
    cp      e
    jp      c,div_8_next
div_8_sub:
    sub     e
    inc     l               ; quotient bit 1
div_8_next:
    dec     b
    jp      nz,div_8_loop
    ld      e,a
    ld      d,0
    or      a               ; clear carry on return
    pop     bc
    ret

div_16:
    ld      bc,hl           ; BC = divisor, kept for callers
    ld      hl,0            ; HL = remainder
    ld      a,16

div_loop:
    ex      de,hl
    adc     hl,hl           ; dividend << 1 | previous quotient bit
    ex      de,hl           ; carry = dividend bit
    adc     hl,hl           ; remainder << 1 | dividend bit
    jp      c,div_force     ; 17-bit remainder: always >= divisor

    sbc     hl,bc           ; carry is clear here, so a plain subtract
    jp      nc,div_one      ; fits: quotient bit 1
    add     hl,bc           ; put the remainder back
    or      a               ; quotient bit 0
    jp      div_next

div_force:
    or      a
    sbc     hl,bc           ; low 16 bits of the 17-bit difference

div_one:
    scf                     ; quotient bit 1

div_next:
    dec     a               ; leaves carry alone
    jp      nz,div_loop

    ex      de,hl           ; HL = quotient register, DE = remainder
    adc     hl,hl           ; shift in the last quotient bit
    ret                     ; HL = quotient, DE = remainder
