
; _Noreturn void exit(int status)

PUBLIC _exit

_exit:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "stdlib/z80/asm_exit.asm"
