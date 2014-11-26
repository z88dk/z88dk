
; ssize_t write(int fd, const void *buf, size_t nbyte)

SECTION seg_code_fcntl

PUBLIC write_callee

write_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "fcntl/z80/asm_write.asm"
