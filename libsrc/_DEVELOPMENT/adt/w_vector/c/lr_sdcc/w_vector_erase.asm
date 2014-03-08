
; size_t w_vector_erase(w_vector_t *v, size_t idx)

XDEF w_vector_erase

w_vector_erase:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_w_vector_erase.asm"
