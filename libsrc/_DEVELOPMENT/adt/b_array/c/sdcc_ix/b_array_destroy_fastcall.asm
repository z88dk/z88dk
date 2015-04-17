
; void b_array_destroy_fastcall(b_array_t *a)

SECTION code_adt_b_array

PUBLIC _b_array_destroy_fastcall

_b_array_destroy_fastcall:
   
   INCLUDE "adt/b_array/z80/asm_b_array_destroy.asm"
