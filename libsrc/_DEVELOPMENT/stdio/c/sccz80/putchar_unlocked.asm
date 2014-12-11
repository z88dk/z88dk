
; int putchar_unlocked(int c)

SECTION code_stdio

PUBLIC putchar_unlocked

putchar_unlocked:

   INCLUDE "stdio/z80/asm_putchar_unlocked.asm"
