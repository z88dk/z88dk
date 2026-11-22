
; wa_priority_queue_t *
; wa_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC _wa_priority_queue_init

EXTERN l0_wa_priority_queue_init_callee

_wa_priority_queue_init:

   pop af
   pop hl
   pop de
   pop bc
   exx
   pop bc
   
   push bc
   push bc
   push de
   push hl
   push af

   jp l0_wa_priority_queue_init_callee
