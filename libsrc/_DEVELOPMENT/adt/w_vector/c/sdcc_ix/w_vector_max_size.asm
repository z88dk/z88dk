
; void *w_vector_max_size(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_max_size

EXTERN asm_w_vector_max_size

_w_vector_max_size:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_w_vector_max_size
