
; size_t w_array_append(w_array_t *a, void *item)

XLIB w_array_append

LIB asm_w_array_append

w_array_append:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_w_array_append
