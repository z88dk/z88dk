
; char *strlwr_fastcall(char *s)

SECTION code_clib
SECTION code_string

PUBLIC _strlwr_fastcall

EXTERN asm_strlwr

defc _strlwr_fastcall = asm_strlwr
