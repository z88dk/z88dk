
; size_t w_vector_capacity(w_vector_t *v)

XLIB w_vector_capacity

LIB asm_w_vector_capacity

w_vector_capacity:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_w_vector_capacity
