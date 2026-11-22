
; void ba_stack_destroy_fastcall(ba_stack_t *s)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC _ba_stack_destroy_fastcall

EXTERN asm_ba_stack_destroy

defc _ba_stack_destroy_fastcall = asm_ba_stack_destroy
