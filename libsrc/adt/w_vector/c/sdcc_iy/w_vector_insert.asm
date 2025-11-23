
; size_t w_vector_insert(w_vector_t *v, size_t idx, void *item)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_insert

EXTERN asm_w_vector_insert

_w_vector_insert:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   jp asm_w_vector_insert
