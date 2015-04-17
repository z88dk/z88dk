
; int bv_stack_empty_fastcall(bv_stack_t *s)

SECTION code_adt_bv_stack

PUBLIC _bv_stack_empty_fastcall

defc _bv_stack_empty_fastcall = asm_bv_stack_empty

INCLUDE "adt/bv_stack/z80/asm_bv_stack_empty.asm"
