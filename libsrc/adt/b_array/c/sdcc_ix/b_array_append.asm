
; size_t b_array_append(b_array_t *a, int c)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_append

EXTERN asm_b_array_append

_b_array_append:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_b_array_append
