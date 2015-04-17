
; int ba_stack_empty_fastcall(ba_stack_t *s)

SECTION code_adt_ba_stack

PUBLIC _ba_stack_empty_fastcall

defc _ba_stack_empty_fastcall = asm_ba_stack_empty

INCLUDE "adt/ba_stack/z80/asm_ba_stack_empty.asm"
