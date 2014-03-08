
; size_t w_vector_append(b_vector_t *v, void *item)

XDEF w_vector_append_callee
XDEF w_vector_push_back_callee

w_vector_append_callee:
w_vector_push_back_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_w_vector_append.asm"
