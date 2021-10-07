;       Z88 Small C+ Run Time Library 
;       Long functions
;       "8080" mode
;       Stefano - 29/4/2002
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_div
EXTERN  l_long_divide

.l_long_div
    ld    a,129
    jp    l_long_divide
