;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION seg_code_sccz80

PUBLIC l_long_com

EXTERN l_cpl_dehl

defc l_long_com = l_cpl_dehl
