
; char *strrev_fastcall(char *s)

SECTION code_clib
SECTION code_string

PUBLIC _strrev_fastcall

EXTERN asm_strrev

defc _strrev_fastcall = asm_strrev
