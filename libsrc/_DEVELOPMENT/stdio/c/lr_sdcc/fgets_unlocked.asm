
; char *fgets(char *s, int n, FILE *stream)

XDEF fgets_unlocked

fgets_unlocked:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   push ix
   
   ld ixl,e
   ld ixh,d
   
   ex de,hl
   call asm_fgets_unlocked
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_fgets_unlocked.asm"
