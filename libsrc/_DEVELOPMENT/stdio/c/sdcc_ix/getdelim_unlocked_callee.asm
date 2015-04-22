
; size_t getdelim_unlocked_callee(char **lineptr, size_t *n, int delimiter, FILE *stream)

SECTION code_stdio

PUBLIC _getdelim_unlocked_callee, l0_getdelim_unlocked_callee

_getdelim_unlocked_callee:

   pop af
   pop hl
   pop de
   pop bc
   exx
   pop bc
   push af

l0_getdelim_unlocked_callee:

   push bc
   exx
   
   ex (sp),ix
   
   call asm_getdelim_unlocked
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_getdelim_unlocked.asm"
