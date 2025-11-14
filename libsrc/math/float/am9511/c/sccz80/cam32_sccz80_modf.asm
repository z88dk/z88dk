
SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_modf

EXTERN _am9511_modf

; float modf(float x, float * y) __stdc

defc cam32_sccz80_modf = _am9511_modf
