
; void *wa_stack_top(wa_stack_t *s)

SECTION seg_code_wa_stack

PUBLIC wa_stack_top

defc wa_stack_top = asm_wa_stack_top

INCLUDE "adt/wa_stack/z80/asm_wa_stack_top.asm"
