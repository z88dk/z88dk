;       Small C+ Z88 Support Library
;
;       Convert unsigned int to float

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_int2long_u_float

EXTERN float

l_int2long_u_float:
   ld de,0
   jp float
