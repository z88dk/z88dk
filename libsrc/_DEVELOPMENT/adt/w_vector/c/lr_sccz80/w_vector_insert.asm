
; size_t w_vector_insert(w_vector_t *v, size_t idx, void *item)

XLIB w_vector_insert

LIB asm_w_vector_insert

w_vector_insert:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   jp asm_w_vector_insert
