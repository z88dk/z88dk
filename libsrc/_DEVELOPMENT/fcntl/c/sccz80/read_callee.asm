
; ssize_t read(int fd, void *buf, size_t nbyte)

SECTION code_clib
SECTION code_fcntl

PUBLIC read_callee

EXTERN asm_read

read_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_read
