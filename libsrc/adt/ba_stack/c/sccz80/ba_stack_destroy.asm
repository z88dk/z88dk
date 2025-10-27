
; void ba_stack_destroy(ba_stack_t *s)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC ba_stack_destroy

EXTERN b_array_destroy

defc ba_stack_destroy = b_array_destroy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ba_stack_destroy
defc _ba_stack_destroy = ba_stack_destroy
ENDIF

