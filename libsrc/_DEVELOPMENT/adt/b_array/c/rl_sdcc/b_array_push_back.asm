
; size_t b_array_push_back(b_array_t *a, int c)

XDEF b_array_push_back

b_array_push_back:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_b_array_push_back.asm"
