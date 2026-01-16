
; size_t ftoe(float x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_clib
SECTION code_stdlib

PUBLIC ftoe_callee

EXTERN dtoe_callee

defc ftoe_callee = dtoe_callee
