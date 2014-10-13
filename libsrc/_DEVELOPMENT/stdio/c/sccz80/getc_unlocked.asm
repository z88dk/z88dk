
; int getc_unlocked(FILE *stream)

SECTION seg_code_stdio

PUBLIC getc_unlocked

EXTERN fgetc_unlocked

defc getc_unlocked = fgetc_unlocked

INCLUDE "stdio/z80/asm_getc_unlocked.asm"
