
; int w_array_resize(w_array_t *a, size_t n)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_resize_callee

EXTERN asm_w_array_resize

w_array_resize_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_w_array_resize
