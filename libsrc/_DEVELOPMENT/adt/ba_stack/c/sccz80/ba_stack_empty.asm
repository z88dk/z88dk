
; int ba_stack_empty(ba_stack_t *s)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC ba_stack_empty

EXTERN asm_ba_stack_empty

defc ba_stack_empty = asm_ba_stack_empty

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ba_stack_empty
defc _ba_stack_empty = ba_stack_empty
ENDIF

