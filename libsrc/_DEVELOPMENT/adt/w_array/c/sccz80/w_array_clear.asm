
; void w_array_clear(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_clear

EXTERN asm_w_array_clear

defc w_array_clear = asm_w_array_clear
