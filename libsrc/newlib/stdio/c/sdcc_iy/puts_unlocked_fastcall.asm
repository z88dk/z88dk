
; int puts_unlocked_fastcall(const char *s)

SECTION code_clib
SECTION code_stdio

PUBLIC _puts_unlocked_fastcall

EXTERN asm_puts_unlocked

defc _puts_unlocked_fastcall = asm_puts_unlocked
