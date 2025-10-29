
; off_t lseek(int fd, off_t offset, int whence)

SECTION code_clib
SECTION code_fcntl

PUBLIC _lseek

EXTERN l0_lseek_callee

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
   
   jp l0_lseek_callee
