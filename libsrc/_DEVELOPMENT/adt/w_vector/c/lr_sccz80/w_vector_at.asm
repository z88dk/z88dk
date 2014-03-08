
; void *w_vector_at(b_vector_t *v, size_t idx)

XLIB w_vector_at

LIB asm_w_vector_at

w_vector_at:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_w_vector_at
