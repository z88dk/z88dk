
; int puts_unlocked(const char *s)

SECTION code_clib
SECTION code_stdio

PUBLIC puts_unlocked

EXTERN asm_puts_unlocked

defc puts_unlocked = asm_puts_unlocked
