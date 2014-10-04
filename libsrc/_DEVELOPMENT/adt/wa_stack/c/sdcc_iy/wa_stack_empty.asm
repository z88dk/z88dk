
; int wa_stack_empty(wa_stack_t *s)

SECTION seg_code_wa_stack

PUBLIC _wa_stack_empty

EXTERN _w_array_empty

defc _wa_stack_empty = _w_array_empty

INCLUDE "adt/wa_stack/z80/asm_wa_stack_empty.asm"
