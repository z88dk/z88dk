
; void *wa_stack_top_fastcall(wa_stack_t *s)

SECTION code_adt_wa_stack

PUBLIC _wa_stack_top_fastcall

defc _wa_stack_top_fastcall = asm_wa_stack_top

INCLUDE "adt/wa_stack/z80/asm_wa_stack_top.asm"
