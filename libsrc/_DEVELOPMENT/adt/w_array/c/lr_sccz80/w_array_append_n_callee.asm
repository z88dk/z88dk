
; size_t w_array_append_n(w_array_t *a, size_t n, void *item)

PUBLIC w_array_append_n_callee

w_array_append_n_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "adt/w_array/z80/asm_w_array_append_n.asm"
