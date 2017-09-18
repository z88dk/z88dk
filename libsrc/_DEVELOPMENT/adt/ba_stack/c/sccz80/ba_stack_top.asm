
; int ba_stack_top(ba_stack_t *s)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC ba_stack_top

EXTERN asm_ba_stack_top

defc ba_stack_top = asm_ba_stack_top

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ba_stack_top
defc _ba_stack_top = ba_stack_top
ENDIF

