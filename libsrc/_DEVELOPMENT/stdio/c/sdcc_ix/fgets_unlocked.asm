
; char *fgets(char *s, int n, FILE *stream)

SECTION code_stdio

PUBLIC _fgets_unlocked

_fgets_unlocked:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   push de
   ex (sp),ix
   
   ex de,hl
   call asm_fgets_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fgets_unlocked.asm"
