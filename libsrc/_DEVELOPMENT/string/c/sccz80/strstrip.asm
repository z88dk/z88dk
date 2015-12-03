
; char *strstrip(const char *s)

SECTION code_clib
SECTION code_string

PUBLIC strstrip

EXTERN asm_strstrip

defc strstrip = asm_strstrip
