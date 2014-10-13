
; int getchar_unlocked(void)

SECTION seg_code_stdio

PUBLIC getchar_unlocked

getchar_unlocked:

   INCLUDE "stdio/z80/asm_getchar_unlocked.asm"
