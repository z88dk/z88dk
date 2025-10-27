;       Z88 Small C+ Run Time Library 
;       Long support functions
;
;       djm 25/2/99
;       Made work! - Seems a little messed up previously (still untested)
;
;       djm 7/5/99
;       This version is called when the optimizer has had a look at
;       the code
;
;       aralbrec 01/2007
;       switched to shifts from slower doubling using de/hl

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_aslo

EXTERN l_lsl_dehl

defc l_long_aslo = l_lsl_dehl
