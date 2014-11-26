
; int creat(const char *path, mode_t mode)

SECTION seg_code_fcntl

PUBLIC _creat

_creat:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af

   INCLUDE "fcntl/z80/asm_creat.asm"
