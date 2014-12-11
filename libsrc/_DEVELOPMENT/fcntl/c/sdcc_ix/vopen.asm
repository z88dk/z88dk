
; int vopen(const char *path, int oflag, void *arg)

SECTION code_fcntl

PUBLIC _vopen

_vopen:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   push ix
   
   call asm_vopen
   
   pop ix
   ret
   
   INCLUDE "fcntl/z80/asm_vopen.asm"
