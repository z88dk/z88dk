
; int fsetpos_unlocked(FILE *stream, const fpos_t *pos)

SECTION code_stdio

PUBLIC _fsetpos_unlocked

_fsetpos_unlocked:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   push bc
   ex (sp),ix
   
   call asm_fsetpos_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fsetpos_unlocked.asm"
