
; void *wa_stack_pop_fastcall(wa_stack_t *s)

SECTION code_adt_wa_stack

PUBLIC _wa_stack_pop_fastcall

defc _wa_stack_pop_fastcall = asm_wa_stack_pop

INCLUDE "adt/wa_stack/z80/asm_wa_stack_pop.asm"
