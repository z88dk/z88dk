
; size_t b_array_erase_block_callee(b_array_t *a, size_t idx, size_t n)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_erase_block_callee

EXTERN asm_b_array_erase_block

_b_array_erase_block_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   jp asm_b_array_erase_block
