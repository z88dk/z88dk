
; off_t lseek_callee(int fd, off_t offset, int whence)

SECTION code_fcntl

PUBLIC _lseek_callee, l0_lseek_callee

_lseek_callee:

   pop bc
   exx
   pop bc
   pop hl
   pop de
   ex (sp),hl
   ld a,l
   pop hl

l0__lseek_callee:

   exx
   push bc
   
   exx

   INCLUDE "fcntl/z80/asm_lseek.asm"
