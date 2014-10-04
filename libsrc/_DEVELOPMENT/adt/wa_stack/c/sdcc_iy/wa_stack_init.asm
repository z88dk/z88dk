
; wa_stack_t *wa_stack_init(void *p, void *data, size_t capacity)

SECTION seg_code_wa_stack

PUBLIC _wa_stack_init

EXTERN _w_array_init

defc _wa_stack_init = _w_array_init

INCLUDE "adt/wa_stack/z80/asm_wa_stack_init.asm"
