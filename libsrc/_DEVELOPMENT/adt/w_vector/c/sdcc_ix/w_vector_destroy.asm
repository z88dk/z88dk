
; void w_vector_destroy(w_vector_t *v)

SECTION seg_code_w_vector

PUBLIC _w_vector_destroy

EXTERN _b_vector_destroy

defc _w_vector_destroy = _b_vector_destroy

INCLUDE "adt/w_vector/z80/asm_w_vector_destroy.asm"
