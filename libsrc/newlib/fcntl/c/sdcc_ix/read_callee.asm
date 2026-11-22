
; ssize_t read_callee(int fd, void *buf, size_t nbyte)

SECTION code_clib
SECTION code_fcntl

PUBLIC _read_callee, l0_read_callee

EXTERN asm_read

_read_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_read_callee:

   push ix
   
   call asm_read
   
   pop ix
   ret
