
; ssize_t read_callee(int fd, void *buf, size_t nbyte)

SECTION code_clib
SECTION code_fcntl

PUBLIC _read_callee

EXTERN asm_read

_read_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_read
