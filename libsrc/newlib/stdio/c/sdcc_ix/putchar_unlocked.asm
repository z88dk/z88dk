
; int putchar_unlocked(int c)

SECTION code_clib
SECTION code_stdio

PUBLIC _putchar_unlocked

EXTERN _putchar_unlocked_fastcall

_putchar_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   jp _putchar_unlocked_fastcall
