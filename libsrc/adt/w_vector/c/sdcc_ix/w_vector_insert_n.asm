
; size_t w_vector_insert_n(w_vector_t *v, size_t idx, size_t n, void *item)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_insert_n

EXTERN l0_w_vector_insert_n_callee

_w_vector_insert_n:

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

   jp l0_w_vector_insert_n_callee
