
; size_t w_vector_insert_n(w_vector_t *v, size_t idx, size_t n, void *item)

XDEF w_vector_insert_n

w_vector_insert_n:

   exx
   pop bc
   exx
   pop hl
   pop bc
   pop de
   pop af
   
   push af
   push de
   push bc
   push hl
   exx
   push bc
   exx
   
   INCLUDE "../../z80/asm_w_vector_insert_n.asm"
