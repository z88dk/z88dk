
; int system_fastcall(const char *string)

SECTION code_clib
SECTION code_stdlib

PUBLIC _system_fastcall

EXTERN asm_system

defc _system_fastcall = asm_system
