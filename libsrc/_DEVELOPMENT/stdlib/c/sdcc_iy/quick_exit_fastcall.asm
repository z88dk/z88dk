
; _Noreturn void quick_exit_fastcall(int status)

SECTION code_stdlib

PUBLIC _quick_exit_fastcall

_quick_exit_fastcall:
   
   INCLUDE "stdlib/z80/asm_quick_exit.asm"
