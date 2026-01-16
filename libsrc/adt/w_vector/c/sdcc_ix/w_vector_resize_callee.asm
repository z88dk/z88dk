
; int w_vector_resize_callee(w_vector_t *v, size_t n)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_resize_callee

EXTERN asm_w_vector_resize

_w_vector_resize_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_w_vector_resize
