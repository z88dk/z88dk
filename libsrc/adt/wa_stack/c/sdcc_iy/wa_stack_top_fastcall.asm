
; void *wa_stack_top_fastcall(wa_stack_t *s)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC _wa_stack_top_fastcall

EXTERN asm_wa_stack_top

defc _wa_stack_top_fastcall = asm_wa_stack_top
