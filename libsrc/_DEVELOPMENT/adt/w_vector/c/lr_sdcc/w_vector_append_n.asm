
; size_t w_vector_append_n(b_vector_t *v, size_t n, void *item)

XDEF w_vector_append_n

w_vector_append_n:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   INCLUDE "../../z80/asm_w_vector_append_n.asm"
