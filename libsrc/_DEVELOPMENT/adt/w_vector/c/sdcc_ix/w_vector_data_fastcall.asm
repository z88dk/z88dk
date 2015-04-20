
; void *w_vector_data_fastcall(b_vector_t *v)

SECTION code_adt_w_vector

PUBLIC _w_vector_data_fastcall

defc _w_vector_data_fastcall = asm_w_vector_data

INCLUDE "adt/w_vector/z80/asm_w_vector_data.asm"
