
; int b_array_resize(b_array_t *a, size_t n)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_resize

EXTERN asm_b_array_resize

b_array_resize:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_b_array_resize
