
; char *gets_unlocked(char *s)

SECTION code_clib
SECTION code_stdio

PUBLIC _gets_unlocked

EXTERN asm_gets_unlocked

_gets_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_gets_unlocked
