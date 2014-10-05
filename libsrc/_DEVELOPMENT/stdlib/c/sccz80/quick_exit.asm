
; _Noreturn void quick_exit(int status)

SECTION seg_code_stdlib

PUBLIC quick_exit

quick_exit:

   INCLUDE "stdlib/z80/asm_quick_exit.asm"
