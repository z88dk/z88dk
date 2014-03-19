
; int w_array_resize(w_array_t *a, size_t n)

XDEF w_array_resize_callee

w_array_resize_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "../../z80/asm_w_array_resize.asm"
