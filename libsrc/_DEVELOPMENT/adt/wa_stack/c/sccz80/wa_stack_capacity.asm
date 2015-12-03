
; size_t wa_stack_capacity(wa_stack_t *s)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC wa_stack_capacity

EXTERN asm_wa_stack_capacity

defc wa_stack_capacity = asm_wa_stack_capacity
