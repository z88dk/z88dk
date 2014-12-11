
; size_t wa_stack_capacity(wa_stack_t *s)

SECTION code_adt_wa_stack

PUBLIC _wa_stack_capacity

EXTERN _w_array_capacity

defc _wa_stack_capacity = _w_array_capacity

INCLUDE "adt/wa_stack/z80/asm_wa_stack_capacity.asm"
