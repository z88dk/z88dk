
; int putc_unlocked(int c, FILE *stream)

SECTION seg_code_stdio

PUBLIC putc_unlocked_callee

EXTERN fputc_unlocked_callee

defc putc_unlocked_callee = fputc_unlocked_callee

INCLUDE "stdio/z80/asm_putc_unlocked.asm"
