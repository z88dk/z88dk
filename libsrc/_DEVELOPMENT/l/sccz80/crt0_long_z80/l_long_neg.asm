;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_neg

EXTERN l_neg_dehl

defc l_long_neg = l_neg_dehl
