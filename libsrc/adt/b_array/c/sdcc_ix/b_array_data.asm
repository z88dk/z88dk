
; void *b_array_data(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_data

EXTERN asm_b_array_data

_b_array_data:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_b_array_data
