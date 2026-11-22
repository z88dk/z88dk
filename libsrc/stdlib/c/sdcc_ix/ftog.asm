
; size_t ftog(float x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ftog

EXTERN _dtog

defc _ftog = _dtog
