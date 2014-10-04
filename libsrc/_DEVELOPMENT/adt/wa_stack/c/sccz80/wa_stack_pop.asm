
; void *wa_stack_pop(wa_stack_t *s)

SECTION seg_code_wa_stack

PUBLIC wa_stack_pop

defc wa_stack_pop = asm_wa_stack_pop

INCLUDE "adt/wa_stack/z80/asm_wa_stack_pop.asm"
