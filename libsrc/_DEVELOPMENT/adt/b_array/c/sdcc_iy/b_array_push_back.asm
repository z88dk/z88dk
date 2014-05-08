
; size_t b_array_push_back(b_array_t *a, int c)

PUBLIC _b_array_push_back

EXTERN _b_array_append

_b_array_push_back:

   jp _b_array_append
   
   INCLUDE "adt/b_array/z80/asm_b_array_push_back.asm"
