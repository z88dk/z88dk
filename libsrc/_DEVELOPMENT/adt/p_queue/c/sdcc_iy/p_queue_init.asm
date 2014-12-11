
; void p_queue_init(void *p)

SECTION code_adt_p_queue

PUBLIC _p_queue_init

EXTERN _p_forward_list_alt_init

defc _p_queue_init = _p_forward_list_alt_init

INCLUDE "adt/p_queue/z80/asm_p_queue_init.asm"
