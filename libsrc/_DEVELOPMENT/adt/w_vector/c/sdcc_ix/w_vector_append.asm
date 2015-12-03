
; size_t w_vector_append(b_vector_t *v, void *item)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_append

EXTERN asm_w_vector_append

_w_vector_append:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_w_vector_append
