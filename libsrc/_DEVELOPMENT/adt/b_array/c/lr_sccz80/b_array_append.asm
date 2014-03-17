
; size_t b_array_append(b_array_t *a, int c)

XLIB b_array_append

LIB asm_b_array_append

b_array_append:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_b_array_append
