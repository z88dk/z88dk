
SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_div_u

; HL = DE / HL, DE = DE % HL
l_div_u:
    ld      bc,hl           ; store divisor to bc
    ld      hl,0            ; clear remainder
    xor     a               ; clear carry
    ld      a,17            ; load loop counter
ccduv1:
    rl      de              ; left shift dividend into carry
    jp      C,ccduv2        ; we have to keep carry -> calling else branch

    dec     a               ; decrement loop counter
    jp      Z,ccduv5

    or     a                ; clear carry
    jp      ccduv3

ccduv2:
    dec     a               ; decrement loop counter
    JP      Z,ccduv5

    scf                     ; set carry
ccduv3:
    ex      de,hl
    rl      de              ; left shift carry into remainder
    ex      de,hl

    sub     hl,bc           ; substract divisor from remainder
    jp      NC,ccduv4       ; if result negative, add back divisor, clear carry

    add     hl,bc           ; add back divisor
    or      a               ; clear carry
    jp      ccduv1

ccduv4:
    scf                     ; set carry
    jp      ccduv1
        
ccduv5:
    ex      de,hl
    ret

