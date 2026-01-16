
; size_t ftoh(float x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ftoh_callee

EXTERN _dtoh_callee

defc _ftoh_callee = _dtoh_callee
