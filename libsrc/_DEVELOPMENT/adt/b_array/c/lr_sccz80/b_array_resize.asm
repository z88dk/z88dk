
; int b_array_resize(b_array_t *a, size_t n)

XLIB b_array_resize

LIB asm_b_array_resize

b_array_resize:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_b_array_resize
