
; void *wv_stack_top_fastcall(wv_stack_t *s)

SECTION code_adt_wv_stack

PUBLIC _wv_stack_top_fastcall

defc _wv_stack_top_fastcall = asm_wv_stack_top

INCLUDE "adt/wv_stack/z80/asm_wv_stack_top.asm"
