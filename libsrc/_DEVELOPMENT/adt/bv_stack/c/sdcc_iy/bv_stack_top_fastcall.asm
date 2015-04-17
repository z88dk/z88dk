
; int bv_stack_top_fastcall(bv_stack_t *s)

SECTION code_adt_bv_stack

PUBLIC _bv_stack_top_fastcall

defc _bv_stack_top_fastcall = asm_bv_stack_top

INCLUDE "adt/bv_stack/z80/asm_bv_stack_top.asm"
