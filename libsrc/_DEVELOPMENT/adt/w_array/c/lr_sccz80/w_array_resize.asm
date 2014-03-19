
; int w_array_resize(w_array_t *a, size_t n)

XLIB w_array_resize

LIB asm_w_array_resize

w_array_resize:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_w_array_resize
