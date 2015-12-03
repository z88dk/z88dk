
; size_t w_array_capacity(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_capacity

EXTERN asm_w_array_capacity

defc w_array_capacity = asm_w_array_capacity
