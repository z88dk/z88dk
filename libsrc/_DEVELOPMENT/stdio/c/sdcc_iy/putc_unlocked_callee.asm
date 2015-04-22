
; int putc_unlocked_callee(int c, FILE *stream)

SECTION code_stdio

PUBLIC _putc_unlocked_callee

EXTERN _fputc_unlocked_callee

defc _putc_unlocked_callee = _fputc_unlocked_callee

INCLUDE "stdio/z80/asm_putc_unlocked.asm"
