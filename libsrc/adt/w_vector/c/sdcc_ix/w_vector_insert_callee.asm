
; size_t w_vector_insert_callee(w_vector_t *v, size_t idx, void *item)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_insert_callee

EXTERN asm_w_vector_insert

_w_vector_insert_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   jp asm_w_vector_insert
