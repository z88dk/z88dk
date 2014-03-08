
; size_t w_vector_insert_n(w_vector_t *v, size_t idx, size_t n, void *item)

XDEF w_vector_insert_n

w_vector_insert_n:

   exx
   pop bc
   exx
   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   exx
   push bc
   exx
   
   INCLUDE "../../z80/asm_w_vector_insert_n.asm"
