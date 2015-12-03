
; size_t b_array_erase(b_array_t *a, size_t idx)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_erase

EXTERN asm_b_array_erase

b_array_erase:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_b_array_erase
