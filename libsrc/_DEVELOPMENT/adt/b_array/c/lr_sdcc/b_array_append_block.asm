
; void *b_array_append_block(b_array_t *a, size_t n)

XDEF b_array_append_block

LIB error_enomem_zc

b_array_append_block:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   call asm_b_array_append_block
   ret nc
   
   jp error_enomem_zc
   
   INCLUDE "../../z80/asm_b_array_append_block.asm"

