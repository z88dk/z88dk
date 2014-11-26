
; int creat(const char *path, mode_t mode)

SECTION seg_code_fcntl

PUBLIC creat_callee

creat_callee:

   pop af
   pop bc
   pop de
   push af
   
   INCLUDE "fcntl/z80/asm_creat.asm"
