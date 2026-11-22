
; size_t ftog(float x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_clib
SECTION code_stdlib

PUBLIC ftog_callee

EXTERN dtog_callee

defc ftog_callee = dtog_callee
