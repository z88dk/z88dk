
; ssize_t read(int fd, void *buf, size_t nbyte)

SECTION code_clib
SECTION code_fcntl

PUBLIC _read

EXTERN asm_read

_read:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_read
