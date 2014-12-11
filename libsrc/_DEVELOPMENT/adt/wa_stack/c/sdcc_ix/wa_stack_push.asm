
; int wa_stack_push(wa_stack_t *s, void *item)

SECTION code_adt_wa_stack

PUBLIC _wa_stack_push

EXTERN _w_array_append

defc _wa_stack_push = _w_array_append

INCLUDE "adt/wa_stack/z80/asm_wa_stack_push.asm"
