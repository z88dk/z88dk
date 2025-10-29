
; size_t w_array_capacity_fastcall(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_capacity_fastcall

EXTERN asm_w_array_capacity

defc _w_array_capacity_fastcall = asm_w_array_capacity
