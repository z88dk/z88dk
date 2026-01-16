
; char *gets_unlocked(char *s)

SECTION code_clib
SECTION code_stdio

PUBLIC gets_unlocked

EXTERN asm_gets_unlocked

defc gets_unlocked = asm_gets_unlocked
