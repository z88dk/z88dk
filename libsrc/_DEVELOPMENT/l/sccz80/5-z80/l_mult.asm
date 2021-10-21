;
;       Small C Z88 runtime library
;
; Multiply two 16 bit numbers hl=hl*de ((un)signed)

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_mult
PUBLIC l_mult_0

EXTERN l_mulu_16_16x16

defc l_mult = l_mulu_16_16x16

; Multiply two 16 bit numbers hl=bc*de ((un)signed)
.l_mult_0
    ld hl,bc
    jp l_mulu_16_16x16
