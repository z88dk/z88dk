
; size_t ftog(float x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_stdlib

PUBLIC ftog

EXTERN dtog

defc ftog = dtog
