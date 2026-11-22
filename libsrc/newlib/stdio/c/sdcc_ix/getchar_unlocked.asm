
; int getchar_unlocked(void)

SECTION code_clib
SECTION code_stdio

PUBLIC _getchar_unlocked

EXTERN asm_getchar_unlocked

defc _getchar_unlocked = asm_getchar_unlocked
