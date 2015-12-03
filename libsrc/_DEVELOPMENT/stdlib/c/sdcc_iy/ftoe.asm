
; size_t ftoe(float x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ftoe

EXTERN _dtoe

defc _ftoe = _dtoe
