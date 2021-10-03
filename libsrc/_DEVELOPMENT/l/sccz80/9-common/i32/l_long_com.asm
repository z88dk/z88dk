;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_com

EXTERN l_cpl_dehl

defc l_long_com = l_cpl_dehl
