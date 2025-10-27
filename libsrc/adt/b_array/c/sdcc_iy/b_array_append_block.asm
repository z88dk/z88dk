
; void *b_array_append_block(b_array_t *a, size_t n)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_append_block

EXTERN l0_b_array_append_block_callee

_b_array_append_block:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp l0_b_array_append_block_callee
