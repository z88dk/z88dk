
; int putchar_unlocked_fastcall(int c)

SECTION code_stdio

PUBLIC _putchar_unlocked_fastcall

_putchar_unlocked_fastcall:

   INCLUDE "stdio/z80/asm_putchar_unlocked.asm"
