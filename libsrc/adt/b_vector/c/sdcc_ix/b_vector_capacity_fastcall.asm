
; size_t b_vector_capacity_fastcall(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_capacity_fastcall

EXTERN _b_array_capacity_fastcall

defc _b_vector_capacity_fastcall = _b_array_capacity_fastcall
