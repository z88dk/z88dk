
; void b_array_destroy(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_destroy

EXTERN asm_b_array_destroy

_b_array_destroy:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_b_array_destroy
