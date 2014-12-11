
; ssize_t read(int fd, void *buf, size_t nbyte)

SECTION code_fcntl

PUBLIC _read

_read:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "fcntl/z80/asm_read.asm"
