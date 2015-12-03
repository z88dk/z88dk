
; w_array_t *w_array_init(void *p, void *data, size_t capacity)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_init_callee

EXTERN asm_w_array_init

w_array_init_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_w_array_init
