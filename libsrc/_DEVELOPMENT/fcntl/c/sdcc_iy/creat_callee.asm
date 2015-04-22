
; int creat_callee(const char *path, mode_t mode)

SECTION code_fcntl

PUBLIC _creat_callee

_creat_callee:

   pop af
   pop de
   pop bc
   push af

   INCLUDE "fcntl/z80/asm_creat.asm"
