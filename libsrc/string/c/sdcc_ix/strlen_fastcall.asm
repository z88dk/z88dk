
; size_t strlen_fastcall(const char *s)

SECTION code_clib
SECTION code_string

PUBLIC _strlen_fastcall

EXTERN asm_strlen

defc _strlen_fastcall = asm_strlen
