
; size_t b_array_append(b_array_t *a, int c)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_append

EXTERN asm_b_array_append

b_array_append:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_b_array_append
