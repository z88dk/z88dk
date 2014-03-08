
; void *w_vector_data(w_vector_t *v)

XLIB w_vector_data

LIB asm_w_vector_data

w_vector_data:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_w_vector_data
