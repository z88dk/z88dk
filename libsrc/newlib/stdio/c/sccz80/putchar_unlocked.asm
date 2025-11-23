
; int putchar_unlocked(int c)

SECTION code_clib
SECTION code_stdio

PUBLIC putchar_unlocked

EXTERN asm_putchar_unlocked

defc putchar_unlocked = asm_putchar_unlocked
