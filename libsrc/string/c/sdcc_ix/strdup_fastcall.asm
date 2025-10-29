
; char *strdup_fastcall(const char * s)

SECTION code_clib
SECTION code_string

PUBLIC _strdup_fastcall

EXTERN asm_strdup

defc _strdup_fastcall = asm_strdup
