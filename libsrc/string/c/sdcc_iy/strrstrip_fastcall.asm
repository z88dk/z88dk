
; char *strrstrip_fastcall(char *s)

SECTION code_clib
SECTION code_string

PUBLIC _strrstrip_fastcall

EXTERN asm_strrstrip

defc _strrstrip_fastcall = asm_strrstrip
