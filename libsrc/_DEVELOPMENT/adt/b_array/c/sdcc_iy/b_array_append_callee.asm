
; size_t b_array_append_callee(b_array_t *a, int c)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_append_callee

EXTERN asm_b_array_append

_b_array_append_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_b_array_append
