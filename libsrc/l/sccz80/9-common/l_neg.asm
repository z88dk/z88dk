;   Z88 Small C+ Run time Library
;   Moved functions over to proper libdefs
;   To make startup code smaller and neater!
;
;   6/9/98  djm

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_neg
PUBLIC  l_hlneg

EXTERN l_neg_hl

defc l_neg = l_neg_hl
defc l_hlneg = l_neg_hl
