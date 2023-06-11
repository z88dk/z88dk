
SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_mult
PUBLIC  l_mult_u
PUBLIC  l_mult_0

; Entry: hl = value1
;        de = value2
; Exit:  hl = value1 * value2

.l_mult
.l_mult_u
    ld      bc,hl
.l_mult_0
    defb    0xf7    ; mul : hlbc = bc * de
    ld      hl,bc
    ret
