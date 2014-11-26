
; int vopen(const char *path, int oflag, void *arg)

SECTION seg_code_fcntl

PUBLIC vopen_callee

vopen_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "fcntl/z80/asm_vopen.asm"
