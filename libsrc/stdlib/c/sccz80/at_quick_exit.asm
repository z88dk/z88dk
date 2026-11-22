
; int at_quick_exit(void (*func)(void))

SECTION code_clib
SECTION code_stdlib

PUBLIC at_quick_exit

EXTERN asm_at_quick_exit

defc at_quick_exit = asm_at_quick_exit
