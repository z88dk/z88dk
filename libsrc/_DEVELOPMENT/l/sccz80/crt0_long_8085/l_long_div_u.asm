;       Z88 Small C+ Run Time Library 
;       Long functions
;       "8080" mode
;       Stefano - 29/4/2002
;

SECTION code_crt0_sccz80

PUBLIC  l_long_div_u
EXTERN  l_long_divide

.l_long_div_u
    ld    a,1
    jp    l_long_divide