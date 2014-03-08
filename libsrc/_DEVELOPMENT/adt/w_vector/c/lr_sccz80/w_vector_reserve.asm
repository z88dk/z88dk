
; int w_vector_reserve(w_vector_t *v, size_t n)

XLIB w_vector_reserve

LIB asm_w_vector_reserve

w_vector_reserve:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_w_vector_reserve
