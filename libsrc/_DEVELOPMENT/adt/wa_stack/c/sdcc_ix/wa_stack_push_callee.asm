
; int wa_stack_push_callee(wa_stack_t *s, void *item)

SECTION code_adt_wa_stack

PUBLIC _wa_stack_push_callee

EXTERN _w_array_append_callee

defc _wa_stack_push_callee = _w_array_append_callee

INCLUDE "adt/wa_stack/z80/asm_wa_stack_push.asm"
