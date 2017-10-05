
; size_t ba_stack_capacity(ba_stack_t *s)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC ba_stack_capacity

EXTERN asm_ba_stack_capacity

defc ba_stack_capacity = asm_ba_stack_capacity

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ba_stack_capacity
defc _ba_stack_capacity = ba_stack_capacity
ENDIF

