
; int b_array_empty_fastcall(b_array_t *a)

SECTION code_adt_b_array

PUBLIC _b_array_empty_fastcall

defc _b_array_empty_fastcall = asm_b_array_empty
   
INCLUDE "adt/b_array/z80/asm_b_array_empty.asm"
