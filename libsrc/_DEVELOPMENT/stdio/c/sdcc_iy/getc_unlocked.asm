
; int getc_unlocked(FILE *stream)

SECTION code_stdio

PUBLIC _getc_unlocked

EXTERN _fgetc_unlocked

defc _getc_unlocked = _fgetc_unlocked

INCLUDE "stdio/z80/asm_getc_unlocked.asm"
