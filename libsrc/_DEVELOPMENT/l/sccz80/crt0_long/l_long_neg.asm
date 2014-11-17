;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION seg_code_sccz80

PUBLIC l_long_neg

EXTERN l_neg_dehl

defc l_long_neg = l_neg_dehl
