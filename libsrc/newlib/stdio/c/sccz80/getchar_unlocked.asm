
; int getchar_unlocked(void)

SECTION code_clib
SECTION code_stdio

PUBLIC getchar_unlocked

EXTERN asm_getchar_unlocked

defc getchar_unlocked = asm_getchar_unlocked
