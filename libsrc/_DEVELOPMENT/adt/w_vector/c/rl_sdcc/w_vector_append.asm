
; size_t w_vector_append(b_vector_t *v, void *item)

XDEF w_vector_append
XDEF w_vector_push_back

w_vector_append:
w_vector_push_back:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_w_vector_append.asm"
