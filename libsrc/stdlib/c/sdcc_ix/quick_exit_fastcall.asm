
; _Noreturn void quick_exit_fastcall(int status)

SECTION code_clib
SECTION code_stdlib

PUBLIC _quick_exit_fastcall

EXTERN asm_quick_exit

defc _quick_exit_fastcall = asm_quick_exit
