
; int dup2_callee(int fd, int fd2)

SECTION code_fcntl

PUBLIC _dup2_callee

_dup2:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "fcntl/z80/asm_dup2.asm"
