
SECTION code_clib
SECTION code_fp_math48

PUBLIC d2mlib, dx2mlib

EXTERN cm48_sdcciyp_d2m48, cm48_sdcciyp_dx2m48

defc d2mlib  = cm48_sdcciyp_d2m48
defc dx2mlib = cm48_sdcciyp_dx2m48
