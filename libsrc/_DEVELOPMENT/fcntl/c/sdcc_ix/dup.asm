
; int dup(int fd)

SECTION seg_code_fcntl

PUBLIC _dup

_dup:

   pop af
   pop hl
   
   push hl
   push af
   
   push ix
   
   call asm_dup
   
   pop ix
   ret

   INCLUDE "fcntl/z80/asm_dup.asm"
