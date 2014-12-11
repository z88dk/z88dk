
; _Noreturn void quick_exit(int status)

SECTION code_stdlib

PUBLIC _quick_exit

_quick_exit:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "stdlib/z80/asm_quick_exit.asm"
