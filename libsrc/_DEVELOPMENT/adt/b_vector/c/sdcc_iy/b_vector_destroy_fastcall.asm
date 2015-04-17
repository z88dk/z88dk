
; void b_vector_destroy_fastcall(b_vector_t *v)

SECTION code_adt_b_vector

PUBLIC _b_vector_destroy_fastcall

_b_vector_destroy_fastcall:
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_destroy.asm"
