
; void *b_array_data(b_array_t *a)

XDEF b_array_data

b_array_data:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_b_array_data

   INCLUDE "../../z80/asm_b_array_data.asm"
