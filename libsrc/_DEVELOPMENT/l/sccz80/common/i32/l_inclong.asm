;       Small C+ Z88 Support Library
;
;       Increment long by 1
;
;       djm 21/2/99
;       Rewritten so that I know it works properly!

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_inclong

EXTERN l_inc_dehl

defc l_inclong = l_inc_dehl
