
; ssize_t write(int fd, const void *buf, size_t nbyte)

SECTION seg_code_fcntl

PUBLIC _write

_write:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "fcntl/z80/asm_write.asm"
