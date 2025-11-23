
; ssize_t write(int fd, const void *buf, size_t nbyte)

SECTION code_clib
SECTION code_fcntl

PUBLIC write_callee

EXTERN asm_write

write_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_write
