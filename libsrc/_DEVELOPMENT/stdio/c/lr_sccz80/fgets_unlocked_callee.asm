
; char *fgets(char *s, int n, FILE *stream)

PUBLIC fgets_unlocked_callee

fgets_unlocked_callee:

   pop af
   pop ix
   pop bc
   pop de
   push af
   
   INCLUDE "stdio/z80/asm_fgets_unlocked.asm"
