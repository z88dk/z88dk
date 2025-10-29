
; int putchar_unlocked(int c)

SECTION code_clib
SECTION code_stdio

PUBLIC _putchar_unlocked

EXTERN asm_putchar_unlocked

_putchar_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_putchar_unlocked
