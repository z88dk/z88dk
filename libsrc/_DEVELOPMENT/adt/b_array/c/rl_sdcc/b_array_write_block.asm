
; size_t b_array_write_block(void *src, size_t n, b_array_t *a, size_t idx)

XDEF b_array_write_block

b_array_write_block:

   pop af
   exx
   pop hl
   exx
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   exx
   push hl
   exx
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_write_block.asm"
