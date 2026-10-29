
; ssize_t read(int fd, void *buf, size_t nbyte)

SECTION code_clib
SECTION code_fcntl

PUBLIC read

EXTERN asm_read

read:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af

   push ix
   call asm_read
   pop ix
   ret
