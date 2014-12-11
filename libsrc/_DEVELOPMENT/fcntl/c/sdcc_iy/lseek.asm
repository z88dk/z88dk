
; off_t lseek(int fd, off_t offset, int whence)

SECTION code_fcntl

PUBLIC _lseek

_lseek:

   pop bc
   exx
   pop bc
   pop hl
   pop de
   ex (sp),hl
   ld a,l
   pop hl
   
   push af
   push de
   push hl
   push bc
   exx
   push bc
   
   exx

   INCLUDE "fcntl/z80/asm_lseek.asm"
