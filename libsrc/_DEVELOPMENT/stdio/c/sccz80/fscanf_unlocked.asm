
; int fscanf_unlocked(FILE *stream, const char *format, ...)

SECTION seg_code_stdio

PUBLIC fscanf_unlocked

fscanf_unlocked:

   INCLUDE "stdio/z80/asm_fscanf_unlocked.asm"
