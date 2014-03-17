
; int b_array_at(b_array_t *a, size_t idx)

XLIB b_array_at

LIB asm_b_array_at

b_array_at:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_b_array_at
