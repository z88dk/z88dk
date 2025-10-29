
; off_t lseek(int fd, off_t offset, int whence)

SECTION code_clib
SECTION code_fcntl

PUBLIC lseek

EXTERN l0_lseek_callee

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
   
   jp l0_lseek_callee
