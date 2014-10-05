
; _Noreturn void exit(int status)

SECTION seg_code_stdlib

PUBLIC exit

exit:

   INCLUDE "stdlib/z80/asm_exit.asm"
