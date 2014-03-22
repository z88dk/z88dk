
; int putc(int c, FILE *stream)

XDEF putc_callee

LIB fputc_callee

defc putc_callee = fputc_callee

INCLUDE "../../z80/asm_putc.asm"
