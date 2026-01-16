
; int wa_stack_empty_fastcall(wa_stack_t *s)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC _wa_stack_empty_fastcall

EXTERN asm_wa_stack_empty

defc _wa_stack_empty_fastcall = asm_wa_stack_empty
