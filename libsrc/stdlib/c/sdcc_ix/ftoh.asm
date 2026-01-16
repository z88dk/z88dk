
; size_t ftoh(float x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ftoh

EXTERN _dtoh

defc _ftoh = _dtoh
