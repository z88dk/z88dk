
; size_t b_array_append_n(b_array_t *a, size_t n, int c)

XDEF b_array_append_n

b_array_append_n:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_append_n.asm"
