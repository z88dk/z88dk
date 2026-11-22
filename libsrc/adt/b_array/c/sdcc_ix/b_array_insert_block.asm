
; void *b_array_insert_block(b_array_t *a, size_t idx, size_t n)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_insert_block

EXTERN asm_b_array_insert_block

_b_array_insert_block:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   jp asm_b_array_insert_block
