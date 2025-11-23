;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm
;       2025/1  feilipu modified for 8085 SUB

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_le
PUBLIC l_le_hlbc

EXTERN l_compare_true
EXTERN l_compare_false

l_le:

    ; DE <= HL [signed]

    ld bc,de

l_le_hlbc:

    ; set carry if true

    sub hl,bc

    jp k,l_compare_false

    jp l_compare_true
