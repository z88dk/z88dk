
; int fgetpos_unlocked(FILE *stream, fpos_t *pos)

SECTION code_stdio

PUBLIC _fgetpos_unlocked

_fgetpos_unlocked:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   push bc
   ex (sp),ix
   
   call asm_fgetpos_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fgetpos_unlocked.asm"
