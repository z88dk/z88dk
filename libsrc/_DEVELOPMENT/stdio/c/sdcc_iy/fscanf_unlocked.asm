
; int fscanf_unlocked(FILE *stream, const char *format, ...)

SECTION code_stdio

PUBLIC _fscanf_unlocked

_fscanf_unlocked:

   INCLUDE "stdio/z80/asm_fscanf_unlocked.asm"
