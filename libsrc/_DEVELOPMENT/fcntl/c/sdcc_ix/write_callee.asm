
; ssize_t write_callee(int fd, const void *buf, size_t nbyte)

SECTION code_fcntl

PUBLIC _write_callee, l0_write_callee

_write_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_write_callee:
   
   push ix
   
   call asm_write
   
   pop ix
   ret
   
   INCLUDE "fcntl/z80/asm_write.asm"
