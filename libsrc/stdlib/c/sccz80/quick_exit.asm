
; _Noreturn void quick_exit(int status)

SECTION code_clib
SECTION code_stdlib

PUBLIC quick_exit

EXTERN asm_quick_exit

defc quick_exit = asm_quick_exit
