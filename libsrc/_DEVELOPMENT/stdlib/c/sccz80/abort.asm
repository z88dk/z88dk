
; _Noreturn void abort(void)

SECTION code_stdlib

PUBLIC abort

abort:

   INCLUDE "stdlib/z80/asm_abort.asm"
