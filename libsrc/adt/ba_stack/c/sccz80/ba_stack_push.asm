
; int ba_stack_push(ba_stack_t *s, int c)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC ba_stack_push

EXTERN b_array_append

defc ba_stack_push = b_array_append

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ba_stack_push
defc _ba_stack_push = ba_stack_push
ENDIF

