
; char *fgets(char *s, int n, FILE *stream)

XDEF fgets_unlocked

fgets_unlocked:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af

   push ix
   
   ld ixl,e
   ld ixh,d
   
   ex de,hl
   call asm_fgets_unlocked
   
   pop ix
   ret

   INCLUDE "../../z80/asm_fgets_unlocked.asm"
