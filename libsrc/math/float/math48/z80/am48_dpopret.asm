
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dpopret, am48_dxpopret

EXTERN mm48__add10

defc am48_dpopret  = mm48__add10 + 1
defc am48_dxpopret = mm48__add10
