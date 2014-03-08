
; size_t w_vector_append_n(b_vector_t *v, size_t n, void *item)

XLIB w_vector_append_n

LIB asm_w_vector_append_n

w_vector_append_n:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   jp asm_w_vector_append_n
