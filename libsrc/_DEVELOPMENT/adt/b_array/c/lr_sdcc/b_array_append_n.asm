
; size_t b_array_append_n(b_array_t *a, size_t n, int c)

XDEF b_array_append_n

b_array_append_n:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_append_n.asm"
