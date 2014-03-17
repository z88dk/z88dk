
; size_t b_array_push_back(b_array_t *a, int c)

XDEF b_array_push_back

b_array_push_back:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_b_array_push_back.asm"
