;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm
;       13/5/99 djm Added carry conditions...
;       2024/6  feilipu modified for 8085 SUB

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_eq
PUBLIC l_eq_hlbc

EXTERN l_compare_true
EXTERN l_compare_false

.l_eq
    ; de == hl

    ld bc,de

.l_eq_hlbc
    ; bc == hl
    ; set carry if true

    sub hl,bc

    scf
    ld hl,1
    ret z

    ccf
    dec l
    ret
