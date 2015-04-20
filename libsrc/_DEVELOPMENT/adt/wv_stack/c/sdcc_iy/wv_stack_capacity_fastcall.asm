
; size_t wv_stack_capacity_fastcall(wv_stack_t *s)

SECTION code_adt_wv_stack

PUBLIC _wv_stack_capacity_fastcall

defc _wv_stack_capacity_fastcall = asm_wv_stack_capacity

INCLUDE "adt/wv_stack/z80/asm_wv_stack_capacity.asm"
