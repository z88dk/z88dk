
; char *fgets(char *s, int n, FILE *stream)

XDEF fgets

fgets:

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
   call asm_fgets
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_fgets.asm"
