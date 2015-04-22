
; size_t getline_unlocked_callee(char **lineptr, size_t *n, FILE *stream)

SECTION code_stdio

PUBLIC _getline_unlocked_callee, l0_getline_unlocked_callee

_getline_unlocked_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_getline_unlocked_callee:

   push bc
   ex (sp),ix
   
   call asm_getline_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_getline_unlocked.asm"
