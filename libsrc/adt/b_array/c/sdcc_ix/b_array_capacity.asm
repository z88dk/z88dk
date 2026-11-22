
; size_t b_array_capacity(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_capacity

EXTERN asm_b_array_capacity

_b_array_capacity:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_b_array_capacity
