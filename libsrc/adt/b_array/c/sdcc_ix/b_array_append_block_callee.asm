
; void *b_array_append_block_callee(b_array_t *a, size_t n)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_append_block_callee, l0_b_array_append_block_callee

EXTERN error_zc, asm_b_array_append_block

_b_array_append_block_callee:

   pop af
   pop hl
   pop de
   push af

l0_b_array_append_block_callee:
 
   call asm_b_array_append_block
   ret nc
   
   jp error_zc
