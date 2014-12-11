
; int getchar_unlocked(void)

SECTION code_stdio

PUBLIC _getchar_unlocked

_getchar_unlocked:

   INCLUDE "stdio/z80/asm_getchar_unlocked.asm"
