;       Small C+ Z88 Support Library
;
;       Decrement long by 1
;
;       djm 21/2/99
;       Rewritten so that I know it works

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_declong

EXTERN l_dec_dehl

defc l_declong = l_dec_dehl
