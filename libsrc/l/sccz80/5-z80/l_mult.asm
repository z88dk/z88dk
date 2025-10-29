;
;       Small C Z88 runtime library
;
; Multiply two 16 bit numbers hl=hl*de (signed)

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_mult
PUBLIC l_mult_0

EXTERN l_muls_16_16x16

defc l_mult = l_muls_16_16x16

; Multiply two 16 bit numbers hl=bc*de (signed)
.l_mult_0
    ld hl,bc
    jp l_muls_16_16x16
