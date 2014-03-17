
; void b_array_destroy(b_array_t *a)

XDEF b_array_destroy

b_array_destroy:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_b_array_destroy
   
   INCLUDE "../../z80/asm_b_array_destroy.asm"
