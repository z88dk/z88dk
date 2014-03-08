
; size_t w_vector_append_n(b_vector_t *v, size_t n, void *item)

XDEF w_vector_append_n

w_vector_append_n:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "../../z80/asm_w_vector_append.asm"
