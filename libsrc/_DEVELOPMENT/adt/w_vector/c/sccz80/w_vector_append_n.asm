
; size_t w_vector_append_n(b_vector_t *v, size_t n, void *item)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_append_n

EXTERN asm_w_vector_append_n

w_vector_append_n:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_w_vector_append_n
