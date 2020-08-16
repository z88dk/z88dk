;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_glong

EXTERN l_long_load_mhl

defc l_glong = l_long_load_mhl
