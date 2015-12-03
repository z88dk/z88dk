
; size_t w_vector_capacity_fastcall(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_capacity_fastcall

EXTERN asm_w_vector_capacity

defc _w_vector_capacity_fastcall = asm_w_vector_capacity
