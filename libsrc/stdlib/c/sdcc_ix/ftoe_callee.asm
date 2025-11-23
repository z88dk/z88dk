
; size_t ftoe(float x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ftoe_callee

EXTERN _dtoe_callee

defc _ftoe_callee = _dtoe_callee
