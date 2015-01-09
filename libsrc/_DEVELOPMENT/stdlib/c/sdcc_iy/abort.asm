
; _Noreturn void abort(void)

SECTION code_stdlib

PUBLIC _abort

_abort:

   INCLUDE "stdlib/z80/asm_abort.asm"
