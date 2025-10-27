
; size_t ftoa(float x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ftoa_callee

EXTERN _dtoa_callee

defc _ftoa_callee = _dtoa_callee
