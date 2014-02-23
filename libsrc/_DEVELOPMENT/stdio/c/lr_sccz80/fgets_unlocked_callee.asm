
; char *fgets(char *s, int n, FILE *stream)

XDEF fgets_unlocked_callee

fgets_unlocked_callee:

   pop af
   pop ix
   pop bc
   pop de
   push af
   
   INCLUDE "../../z80/asm_fgets_unlocked.asm"
