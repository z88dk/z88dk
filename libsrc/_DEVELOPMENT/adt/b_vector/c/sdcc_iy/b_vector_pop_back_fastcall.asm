
; int b_vector_pop_back_fastcall(b_vector_t *v)

SECTION code_adt_b_vector

PUBLIC _b_vector_pop_back_fastcall

EXTERN _b_array_pop_back_fastcall

defc _b_vector_pop_back_fastcall = _b_array_pop_back_fastcall

INCLUDE "adt/b_vector/z80/asm_b_vector_pop_back.asm"
