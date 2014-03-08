
; size_t w_vector_insert_n(w_vector_t *v, size_t idx, size_t n, void *item)

XLIB w_vector_insert_n

LIB asm_w_vector_insert_n

w_vector_insert_n:

   pop ix
   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   push ix
   
   jp asm_w_vector_insert_n
