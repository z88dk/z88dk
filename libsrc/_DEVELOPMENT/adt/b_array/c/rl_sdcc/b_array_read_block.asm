
; size_t b_array_read_block(void *dst, size_t n, b_array_t *a, size_t idx)

XDEF b_array_read_block

b_array_read_block:

   pop af
   exx
   pop de
   exx
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   exx
   push de
   exx
   push af

   INCLUDE "../../z80/asm_b_array_read_block.asm"
