
; size_t b_array_size(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_size

EXTERN asm_b_array_size

_b_array_size:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_b_array_size
