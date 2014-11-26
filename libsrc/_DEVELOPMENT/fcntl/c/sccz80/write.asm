
; ssize_t write(int fd, const void *buf, size_t nbyte)

SECTION seg_code_fcntl

PUBLIC write

EXTERN asm_write

write:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_write
