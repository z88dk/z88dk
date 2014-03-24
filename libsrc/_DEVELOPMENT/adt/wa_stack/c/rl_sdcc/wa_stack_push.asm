
; int wa_stack_push(wa_stack_t *s, void *item)

XDEF wa_stack_push

LIB w_array_append

defc wa_stack_push = w_array_append

INCLUDE "adt/wa_stack/z80/asm_wa_stack_push.asm"
