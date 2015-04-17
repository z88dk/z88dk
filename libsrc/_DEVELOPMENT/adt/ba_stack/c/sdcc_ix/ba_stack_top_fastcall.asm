
; int ba_stack_top_fastcall(ba_stack_t *s)

SECTION code_adt_ba_stack

PUBLIC _ba_stack_top_fastcall

defc _ba_stack_top_fastcall = asm_ba_stack_top

INCLUDE "adt/ba_stack/z80/asm_ba_stack_top.asm"
