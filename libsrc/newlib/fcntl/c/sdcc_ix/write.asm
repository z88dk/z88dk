
; ssize_t write(int fd, const void *buf, size_t nbyte)

SECTION code_clib
SECTION code_fcntl

PUBLIC _write

EXTERN l0_write_callee

_write:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   jp l0_write_callee
