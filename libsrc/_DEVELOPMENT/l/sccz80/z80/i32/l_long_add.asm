;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_add

EXTERN l_long_add_stack

defc l_long_add = l_long_add_stack
