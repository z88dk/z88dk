
; _Noreturn void exit_fastcall(int status)

SECTION code_clib
SECTION code_stdlib

PUBLIC _exit_fastcall

EXTERN asm_exit

defc _exit_fastcall = asm_exit
