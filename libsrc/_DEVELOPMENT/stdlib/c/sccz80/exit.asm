
; _Noreturn void exit(int status)

SECTION code_stdlib

PUBLIC exit

EXTERN asm_exit

defc exit = asm_exit
