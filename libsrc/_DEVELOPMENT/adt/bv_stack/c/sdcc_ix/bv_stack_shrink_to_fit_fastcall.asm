
; int bv_stack_shrink_to_fit_fastcall(bv_stack_t *s)

SECTION code_adt_bv_stack

PUBLIC _bv_stack_shrink_to_fit_fastcall

defc _bv_stack_shrink_to_fit_fastcall = asm_bv_stack_shrink_to_fit

INCLUDE "adt/bv_stack/z80/asm_bv_stack_shrink_to_fit.asm"
