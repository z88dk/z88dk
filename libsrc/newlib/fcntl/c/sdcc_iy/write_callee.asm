
; ssize_t write_callee(int fd, const void *buf, size_t nbyte)

SECTION code_clib
SECTION code_fcntl

PUBLIC _write_callee

EXTERN asm_write

_write_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_write
