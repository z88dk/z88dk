
; char *strdup(const char * s)

SECTION code_clib
SECTION code_string

PUBLIC strdup

EXTERN asm_strdup

defc strdup = asm_strdup
