
; off_t lseek(int fd, off_t offset, int whence)

SECTION code_fcntl

PUBLIC lseek_callee

lseek_callee:

   pop bc
   exx
   pop bc
   ld a,c
   pop hl
   pop de
   pop bc
   exx
   push bc
   exx
   
   INCLUDE "fcntl/z80/asm_lseek.asm"
