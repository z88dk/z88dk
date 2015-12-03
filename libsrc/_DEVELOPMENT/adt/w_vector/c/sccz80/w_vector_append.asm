
; size_t w_vector_append(b_vector_t *v, void *item)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_append

EXTERN asm_w_vector_append

w_vector_append:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_w_vector_append
