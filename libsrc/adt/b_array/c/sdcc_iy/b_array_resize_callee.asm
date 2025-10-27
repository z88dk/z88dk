
; int b_array_resize_callee(b_array_t *a, size_t n)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_resize_callee

EXTERN asm_b_array_resize

_b_array_resize_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_b_array_resize
