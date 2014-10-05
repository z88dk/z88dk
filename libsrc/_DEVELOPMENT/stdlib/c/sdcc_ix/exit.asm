
; _Noreturn void exit(int status)

SECTION seg_code_stdlib

PUBLIC _exit

_exit:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "stdlib/z80/asm_exit.asm"
