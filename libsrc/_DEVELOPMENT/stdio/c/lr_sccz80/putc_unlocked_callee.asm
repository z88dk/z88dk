
; int putc_unlocked(int c, FILE *stream)

XDEF putc_unlocked_callee

LIB fputc_unlocked_callee

;defc putc_unlocked_callee = fputc_unlocked_callee

putc_unlocked_callee:

   jp fputc_unlocked_callee

INCLUDE "stdio/z80/asm_putc_unlocked.asm"
