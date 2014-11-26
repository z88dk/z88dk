
; off_t lseek(int fd, off_t offset, int whence)

SECTION seg_code_fcntl

PUBLIC lseek

EXTERN asm_lseek

lseek:

   pop bc
   exx
   pop bc
   ld a,c
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push bc
   exx
   push bc
   
   exx
   jp asm_lseek
