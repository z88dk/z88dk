
; off_t lseek(int fd, off_t offset, int whence)

SECTION code_clib
SECTION code_fcntl

PUBLIC lseek_callee, l0_lseek_callee

EXTERN asm_lseek

lseek_callee:

   pop bc
   exx
   pop bc
   ld a,c
   pop hl
   pop de
   pop bc

l0_lseek_callee:

   exx
   push bc
   exx
   
   jp asm_lseek
