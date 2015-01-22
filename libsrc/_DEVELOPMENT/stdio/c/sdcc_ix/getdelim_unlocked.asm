
; size_t getdelim_unlocked(char **lineptr, size_t *n, int delimiter, FILE *stream)

SECTION code_stdio

PUBLIC _getdelim_unlocked

_getdelim_unlocked:

   pop af
   pop hl
   pop de
   pop bc
   exx
   pop bc
   
   push bc
   exx
   push bc
   push de
   push hl
   push af
   
   exx
   push bc
   exx
   
   ex (sp),ix
   
   call asm_getdelim_unlocked
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_getdelim_unlocked.asm"
