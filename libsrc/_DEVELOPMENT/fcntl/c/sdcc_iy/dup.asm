
; int dup(int fd)

SECTION code_fcntl

PUBLIC _dup

_dup:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "fcntl/z80/asm_dup.asm"
