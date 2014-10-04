
; void b_array_destroy(b_array_t *a)

SECTION seg_code_b_array

PUBLIC _b_array_destroy

_b_array_destroy:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_destroy.asm"
