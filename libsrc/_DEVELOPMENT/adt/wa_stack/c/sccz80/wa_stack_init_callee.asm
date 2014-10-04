
; wa_stack_t *wa_stack_init(void *p, void *data, size_t capacity)

SECTION seg_code_wa_stack

PUBLIC wa_stack_init_callee

EXTERN w_array_init_callee

defc wa_stack_init_callee = w_array_init_callee

INCLUDE "adt/wa_stack/z80/asm_wa_stack_init.asm"
