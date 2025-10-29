
; char *strstrip_fastcall(const char *s)

SECTION code_clib
SECTION code_string

PUBLIC _strstrip_fastcall

EXTERN asm_strstrip

defc _strstrip_fastcall = asm_strstrip
