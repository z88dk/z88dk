;
;       Small C Z88 runtime library
;
; Multiply two 16 bit numbers hl=hl*de (unsigned)

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_mult_u
PUBLIC l_mult_u_0

EXTERN l_mulu_16_16x16

defc l_mult_u = l_mulu_16_16x16

; Multiply two 16 bit numbers hl=bc*de (unsigned)
.l_mult_u_0
    ld hl,bc
    jp l_mulu_16_16x16
