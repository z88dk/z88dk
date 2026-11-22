;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm
;       2025/1  feilipu modified for 8085 SUB

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_ult
PUBLIC l_ult_hlbc

EXTERN l_compare_true
EXTERN l_compare_false

l_ult:

    ; DE < HL [unsigned]

    ld bc,de

l_ult_hlbc:

    ; set carry if true

    sub hl,bc

    jp c,l_compare_false
    jp z,l_compare_false

    jp l_compare_true
