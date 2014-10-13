
; int fprintf_unlocked(FILE *stream, const char *format, ...)

SECTION seg_code_stdio

PUBLIC fprintf_unlocked

fprintf_unlocked:

   INCLUDE "stdio/z80/asm_fprintf_unlocked.asm"
