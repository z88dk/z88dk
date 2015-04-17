
; size_t ba_stack_size_fastcall(ba_stack_t *s)

SECTION code_adt_ba_stack

PUBLIC _ba_stack_size_fastcall

defc _ba_stack_size_fastcall = asm_ba_stack_size

INCLUDE "adt/ba_stack/z80/asm_ba_stack_size.asm"
