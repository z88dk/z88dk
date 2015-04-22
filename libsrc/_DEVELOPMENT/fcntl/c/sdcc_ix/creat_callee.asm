
; int creat_callee(const char *path, mode_t mode)

SECTION code_fcntl

PUBLIC _creat_callee, l0_creat_callee

_creat_callee:

   pop af
   pop de
   pop bc
   push af

l0_creat_callee:

   push ix
   
   call asm_creat
   
   pop ix
   ret

   INCLUDE "fcntl/z80/asm_creat.asm"
