
; int w_vector_resize(w_vector_t *v, size_t n)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_resize

EXTERN asm_w_vector_resize

_w_vector_resize:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_w_vector_resize
