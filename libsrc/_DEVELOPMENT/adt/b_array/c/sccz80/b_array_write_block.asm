
; size_t b_array_write_block(void *src, size_t n, b_array_t *a, size_t idx)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_write_block

EXTERN asm_b_array_write_block

b_array_write_block:

   pop af
   pop bc
   pop hl
   pop de
   exx
   pop hl
   
   push hl
   exx
   push de
   push hl
   push bc
   push af
   
   jp asm_b_array_write_block
