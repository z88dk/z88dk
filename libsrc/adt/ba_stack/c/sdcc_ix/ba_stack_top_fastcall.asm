
; int ba_stack_top_fastcall(ba_stack_t *s)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC _ba_stack_top_fastcall

EXTERN asm_ba_stack_top

defc _ba_stack_top_fastcall = asm_ba_stack_top
