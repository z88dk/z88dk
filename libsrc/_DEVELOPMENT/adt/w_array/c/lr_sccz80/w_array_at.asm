
; void *w_array_at(w_array_t *a, size_t idx)

XLIB w_array_at

LIB asm_w_array_at

w_array_at:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_w_array_at
