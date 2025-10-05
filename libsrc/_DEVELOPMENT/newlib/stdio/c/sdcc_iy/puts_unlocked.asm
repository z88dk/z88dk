
; int puts_unlocked(const char *s)

SECTION code_clib
SECTION code_stdio

PUBLIC _puts_unlocked

EXTERN asm_puts_unlocked

_puts_unlocked:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_puts_unlocked
