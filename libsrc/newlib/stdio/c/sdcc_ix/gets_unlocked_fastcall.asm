
; char *gets_unlocked_fastcall(char *s)

SECTION code_clib
SECTION code_stdio

PUBLIC _gets_unlocked_fastcall

EXTERN asm_gets_unlocked

defc _gets_unlocked_fastcall = asm_gets_unlocked
