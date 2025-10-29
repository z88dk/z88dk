
; ssize_t write(int fd, const void *buf, size_t nbyte)

SECTION code_clib
SECTION code_fcntl

PUBLIC _write

EXTERN asm_write

_write:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_write
