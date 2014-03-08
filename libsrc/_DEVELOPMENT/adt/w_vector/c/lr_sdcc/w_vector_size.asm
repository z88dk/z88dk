
; void *w_vector_size(w_vector_t *v)

XLIB w_vector_size

LIB asm_w_vector_size

w_vector_size:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_w_vector_size
