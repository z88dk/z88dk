
; _Noreturn void exit_fastcall(int status)

SECTION code_stdlib

PUBLIC _exit_fastcall

_exit_fastcall:
   
   INCLUDE "stdlib/z80/asm_exit.asm"
