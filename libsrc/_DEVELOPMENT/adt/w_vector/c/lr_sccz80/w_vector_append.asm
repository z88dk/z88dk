
; size_t w_vector_append(b_vector_t *v, void *item)

XLIB w_vector_append
XDEF w_vector_push_back

LIB asm_w_vector_append

w_vector_append:
w_vector_push_back:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_w_vector_append
