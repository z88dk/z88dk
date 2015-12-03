
; size_t w_vector_insert(w_vector_t *v, size_t idx, void *item)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_insert

EXTERN asm_w_vector_insert

w_vector_insert:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   jp asm_w_vector_insert
