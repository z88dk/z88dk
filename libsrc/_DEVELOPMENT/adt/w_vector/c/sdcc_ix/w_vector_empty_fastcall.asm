
; void w_vector_empty_fastcall(w_vector_t *v)

SECTION code_adt_w_vector

PUBLIC _w_vector_empty_fastcall

defc _w_vector_empty_fastcall = asm_w_vector_empty

INCLUDE "adt/w_vector/z80/asm_w_vector_empty.asm"
