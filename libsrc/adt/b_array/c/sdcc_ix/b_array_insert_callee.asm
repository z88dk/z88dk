
; size_t b_array_insert_callee(b_array_t *a, size_t idx, int c)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_insert_callee

EXTERN asm_b_array_insert

_b_array_insert_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   jp asm_b_array_insert
