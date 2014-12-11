
; int putc_unlocked(int c, FILE *stream)

SECTION code_stdio

PUBLIC _putc_unlocked

EXTERN _fputc_unlocked

defc _putc_unlocked = _fputc_unlocked

INCLUDE "stdio/z80/asm_putc_unlocked.asm"
