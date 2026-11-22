
; int at_quick_exit_fastcall(void (*func)(void))

SECTION code_clib
SECTION code_stdlib

PUBLIC _at_quick_exit_fastcall

EXTERN asm_at_quick_exit

defc _at_quick_exit_fastcall = asm_at_quick_exit
