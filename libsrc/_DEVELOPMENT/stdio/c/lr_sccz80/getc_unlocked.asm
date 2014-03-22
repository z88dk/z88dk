
; int getc_unlocked(FILE *stream)

XDEF getc_unlocked

LIB fgetc_unlocked

defc getc_unlocked = fgetc_unlocked

INCLUDE "../../z80/asm_getc_unlocked.asm"
