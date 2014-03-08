
; size_t w_vector_erase(w_vector_t *v, size_t idx)

XLIB w_vector_erase

LIB asm_w_vector_erase

w_vector_erase:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_w_vector_erase
