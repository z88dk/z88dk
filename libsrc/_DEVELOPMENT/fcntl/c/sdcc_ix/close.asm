
; int close(int fd)

SECTION code_fcntl

PUBLIC _close

_close:

   pop af
   pop hl
   
   push hl
   push af
   
   push ix
   
   call asm_close
   
   pop ix
   ret

   INCLUDE "fcntl/z80/asm_close.asm"
