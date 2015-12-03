
; size_t ftoh(float x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_clib
SECTION code_stdlib

PUBLIC ftoh_callee

EXTERN dtoh_callee

defc ftoh_callee = dtoh_callee
