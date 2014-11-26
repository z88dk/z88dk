
; ssize_t read(int fd, void *buf, size_t nbyte)

SECTION seg_code_fcntl

PUBLIC read_callee

read_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "fcntl/z80/asm_read.asm"
