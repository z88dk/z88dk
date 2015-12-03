
; size_t w_array_append_n(w_array_t *a, size_t n, void *item)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_append_n_callee

EXTERN asm_w_array_append_n

w_array_append_n_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_w_array_append_n
