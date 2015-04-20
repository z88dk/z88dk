
; ssize_t read_callee(int fd, void *buf, size_t nbyte)

SECTION code_fcntl

PUBLIC _read_callee

_read_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   INCLUDE "fcntl/z80/asm_read.asm"
