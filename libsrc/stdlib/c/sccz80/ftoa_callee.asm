
; size_t ftoa(float x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_clib
SECTION code_stdlib

PUBLIC ftoa_callee

EXTERN dtoa_callee

defc ftoa_callee = dtoa_callee
