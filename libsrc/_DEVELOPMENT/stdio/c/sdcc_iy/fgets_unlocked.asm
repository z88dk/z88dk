
; char *fgets(char *s, int n, FILE *stream)

XDEF fgets_unlocked

fgets_unlocked:

   pop af
   pop de
   pop bc
   pop ix
   
   push ix
   push bc
   push de
   push af
   
   INCLUDE "stdio/z80/asm_fgets_unlocked.asm"
