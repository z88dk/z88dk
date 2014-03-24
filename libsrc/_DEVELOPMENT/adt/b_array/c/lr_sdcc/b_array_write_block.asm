
; size_t b_array_write_block(void *src, size_t n, b_array_t *a, size_t idx)

XDEF b_array_write_block

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
   
   INCLUDE "adt/b_array/z80/asm_b_array_write_block.asm"
