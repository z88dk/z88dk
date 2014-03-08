
; size_t w_vector_erase_range(w_vector_t *v, size_t idx_first, size_t idx_last)

XLIB w_vector_erase_range

LIB asm_w_vector_erase_range

w_vector_erase_range:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   jp asm_w_vector_erase_range
