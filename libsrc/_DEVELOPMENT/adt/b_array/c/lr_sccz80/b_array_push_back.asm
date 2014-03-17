
; size_t b_array_push_back(b_array_t *a, int c)

XLIB b_array_push_back

LIB asm_b_array_push_back

b_array_push_back:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_b_array_push_back
