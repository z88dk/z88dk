
; int w_vector_reserve(w_vector_t *v, size_t n)

PUBLIC w_vector_reserve

EXTERN asm_w_vector_reserve

w_vector_reserve:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_w_vector_reserve
