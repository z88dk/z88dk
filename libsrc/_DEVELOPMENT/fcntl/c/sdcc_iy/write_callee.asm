
; ssize_t write_callee(int fd, const void *buf, size_t nbyte)

SECTION code_fcntl

PUBLIC _write_callee

_write_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   INCLUDE "fcntl/z80/asm_write.asm"
