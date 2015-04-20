
; void *w_vector_pop_back_fastcall(w_vector_t *v)

SECTION code_adt_w_vector

PUBLIC _w_vector_pop_back_fastcall

defc _w_vector_pop_back_fastcall = asm_w_vector_pop_back

INCLUDE "adt/w_vector/z80/asm_w_vector_pop_back.asm"
