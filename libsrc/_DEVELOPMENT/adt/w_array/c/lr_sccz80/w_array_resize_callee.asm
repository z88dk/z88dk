
; int w_array_resize(w_array_t *a, size_t n)

PUBLIC w_array_resize_callee

w_array_resize_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "adt/w_array/z80/asm_w_array_resize.asm"
