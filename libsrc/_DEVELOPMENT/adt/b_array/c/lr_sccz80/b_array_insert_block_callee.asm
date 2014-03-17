
; void *b_array_insert_block(b_array_t *a, size_t idx, size_t n)

XDEF b_array_insert_block_callee

b_array_insert_block_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCUDE "../../z80/asm_b_array_insert_block.asm"
