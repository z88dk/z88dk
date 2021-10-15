; sccz80 crt0 library - 8085 version

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_div_u

; HL = DE / HL, DE = DE % HL
l_div_u:
    ld      bc,hl           ; store divisor to bc
    ld      hl,0            ; clear remainder
    ld      a,17            ; load loop counter
    or      a               ; clear carry
ccduv1:
    rl      de              ; left shift dividend into carry
    dec     a               ; decrement loop counter
    jp      Z,ccduv3

    ex      de,hl
    rl      de              ; left shift carry into remainder
    ex      de,hl

    sub     hl,bc           ; substract divisor from remainder
    jp      NC,ccduv2       ; if result negative, add back divisor, clear carry

    add     hl,bc           ; add back divisor
    or      a               ; clear carry
    jp      ccduv1

ccduv2:
    scf                     ; set carry
    jp      ccduv1
        
ccduv3:
    ex      de,hl
    ret

