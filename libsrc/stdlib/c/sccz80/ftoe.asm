
; size_t ftoe(float x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_clib
SECTION code_stdlib

PUBLIC ftoe

EXTERN dtoe

defc ftoe = dtoe
